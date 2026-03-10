# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;

  # 1. GEMEINSAME MODULE (Nur einmal definieren!)
  modules = {
    "custom/nixos" = { format = ""; tooltip = false; };
    "hyprland/workspaces" = { format = "{icon}"; on-click = "activate"; format-icons = { active = ""; default = ""; }; };
    "hyprland/window" = { format = "{title}"; max-length = 50; };
    "clock" = { format = " {:%H:%M}"; tooltip-format = "<tt>{calendar}</tt>"; };
    "idle_inhibitor" = { format = "{icon}"; format-icons = { activated = ""; deactivated = ""; }; };
    "tray" = { icon-size = 14; spacing = 6; };
    "custom/power" = { format = "⏻"; on-click = "wlogout"; };
    "network" = { format-wifi = " {essid}"; format-ethernet = "󰈀 LAN"; format-disconnected = "⚠ Offline"; };
    "cpu" = { format = " {usage}%"; };
    "memory" = { format = " {percentage}%"; };
    "backlight" = { format = "{icon} {percent}%"; format-icons = ["󰃞" "󰃟" "󰃠"]; };
    "pulseaudio" = { format = "{icon} {volume}%"; format-muted = " Muted"; format-icons = { headphone = ""; default = ["" ""]; }; };
    "battery" = { states = { warning = 30; critical = 15; }; format = "{icon} {capacity}%"; format-charging = " {capacity}%"; format-icons = ["" "" "" "" ""]; };
  };

  # 2. TEMPLATES FÜR DIE LEISTEN
  # --- NOVA PROFILE & DEFFAULT---
  mkTopBar = output: {
    name = "topbar";
    layer = "top";
    position = "top";
    height = 20;
    spacing = 4;
    inherit output;
    modules-left = [ "custom/nixos" "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "idle_inhibitor" "tray" "clock" "custom/power" ];
  } // modules;

  mkBottomBar = output: {
    name = "bottombar";
    layer = "top";
    position = "bottom";
    height = 20;
    spacing = 4;
    inherit output;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ];
  } // modules;

  # --- QUASAR PROFILE ---
  # Hauptmonitor (DP-1): Volle Top-Bar
  mkTopBarQuasarMain = output: mkTopBar output;

  # Quasar Bottom-Bar: Wie Nova, aber ohne Backlight und Batterie
  mkBottomBarQuasar = output: {
    name = "bottombar-quasar";
    layer = "top";
    position = "bottom";
    height = 20;
    spacing = 4;
    inherit output;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" "pulseaudio" ]; 
  } // modules;

  # Quasar Zweit-Monitor Top-Bar: Hardware-Module wandern nach oben
  mkTopBarQuasarSec = output: {
    name = "topbar-quasar-sec";
    layer = "top";
    position = "top";
    height = 20;
    spacing = 4;
    inherit output;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" "pulseaudio" ]; 
  } // modules;

  # 3. DIE MODI GENERIEREN
  modeLaptop      = [ (mkTopBar "eDP-1") (mkBottomBar "eDP-1") ];
  modeDocking     = [ (mkTopBar "DP-6")  (mkBottomBar "eDP-1") ];
  modeDockingOnly = [ (mkTopBar "DP-6")  (mkBottomBar "DP-6")  ];

  # Quasar (Workstation)
  modeQuasarSingle = [ (mkTopBar "DP-1") (mkBottomBarQuasar "DP-1") ];
  modeQuasarDual   = [ (mkTopBar "DP-1") (mkTopBarQuasarSec "HDMI-A-1") ];

  # 4. DAS INTELLIGENTE SWITCHER-SKRIPT (Erweitert)
  barSwitcher = pkgs.writeShellScriptBin "statusbar-switcher" ''
    ${pkgs.procps}/bin/pkill -f waybar
    sleep 0.5
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')
    
    # --- QUASAR LOGIK (Workstation) ---
    # Wenn DP-1 UND HDMI-A-1 aktiv sind: Dual-Monitor Modus (Zwei Top-Bars)
    if echo "$MONITORS" | grep -q "DP-1" && echo "$MONITORS" | grep -q "HDMI-A-1"; then
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-quasar-dual -s ~/.config/waybar/style.css &
    
    # Wenn NUR DP-1 aktiv ist: Single-Monitor Modus (Top & Bottom Bar)
    elif echo "$MONITORS" | grep -q "DP-1"; then
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-quasar-single -s ~/.config/waybar/style.css &
    
    # --- NOVA LOGIK (Laptop) ---
    elif echo "$MONITORS" | grep -q "DP-6" && echo "$MONITORS" | grep -q "eDP-1"; then
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-docking -s ~/.config/waybar/style.css &
    elif echo "$MONITORS" | grep -q "DP-6"; then
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-docking-only -s ~/.config/waybar/style.css &
    else
      ${pkgs.waybar}/bin/waybar -c ~/.config/waybar/config-laptop -s ~/.config/waybar/style.css &
    fi
  '';

  # 4.b NEU: DER VERBESSERTE EVENT-LISTENER
  #barListener = pkgs.writeShellScriptBin "statusbar-listener" ''
  #  # 1. WICHTIG: Warte 2 Sekunden nach dem Hyprland-Start, 
  #  # damit Monitore und Sockets zu 100% bereit sind.
  #  sleep 2
  #  # 2. Führe das initiale Setup für den aktuellen Monitor-Zustand aus
  #  ${barSwitcher}/bin/statusbar-switcher
  #  # 3. Lausche auf Events (mit einer Endlosschleife, falls socat mal abbricht)
  #  SOCKET="UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  #  while true; do
  #    ${pkgs.socat}/bin/socat -U - $SOCKET | while read -r line; do
  #      if [[ "$line" == "monitoradded"* ]] || [[ "$line" == "monitorremoved"* ]]; then
  #        # Kurze Verzögerung, damit Hyprland den neuen Monitor registrieren kann, 
  #        # bevor der Switcher die neuen Daten abfragt
  #        sleep 1
  #        ${barSwitcher}/bin/statusbar-switcher
  #      fi
  #    done
  #    # Falls socat crasht, warte 1 Sekunde und starte es neu
  #    sleep 1
  #  done
  #'';

in {
  # Wir fügen unser neues Skript und jq (zum JSON-Parsen) den Paketen hinzu
  home.packages = [
    barSwitcher
    # barListener
    pkgs.jq
    # pkgs.socat 
  ];

  # Die Konfigurationsdateien in ~/.config/waybar/ schreiben
  xdg.configFile."waybar/config-laptop".text = builtins.toJSON modeLaptop;
  xdg.configFile."waybar/config-docking".text = builtins.toJSON modeDocking;
  xdg.configFile."waybar/config-docking-only".text = builtins.toJSON modeDockingOnly;

  xdg.configFile."waybar/config-quasar-single".text = builtins.toJSON modeQuasarSingle;
  xdg.configFile."waybar/config-quasar-dual".text = builtins.toJSON modeQuasarDual;

  programs.waybar = {
    enable = true;
    # systemd aus, da unser Skript das Starten übernimmt
    systemd.enable = false;
    
    # Das Styling (genau mit deinen gewünschten px-Werten!)
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "${theme.ui.font_propo}", monospace;
          font-size: 9px; 
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(5, 5, 20, ${theme.ui.opacity});
          color: #${theme.colors.fg};
      }

      window#waybar.topbar {
          border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.pink};
      }

      window#waybar.bottombar {
          border-top: ${toString theme.ui.border_size}px solid #${theme.colors.cyan};
      }

      #workspaces button, #clock, #battery, #network, #pulseaudio, 
      #backlight, #memory, #cpu, #tray, #idle_inhibitor, #custom-power, #custom-nixos {
          padding: 1px 3px;
          margin: 1px 4px;
          color: #${theme.colors.white};
      }

      #window {
          font-size: 11px;
          padding: 1px 3px;
          margin: 1px 4px;
          color: #${theme.colors.cyan};
          font-weight: bold;
      }

      #workspaces button { color: #${theme.colors.inactive}; }
      #workspaces button.active { color: #${theme.colors.pink}; font-weight: bold; }

      #battery.charging { color: #${theme.colors.green}; }
      #battery.warning:not(.charging) { color: #${theme.colors.orange}; }
      #battery.critical:not(.charging) { color: #${theme.colors.red}; animation: blink 2s linear infinite; }
      @keyframes blink { 50% { opacity: 0.3; } }
    '';
  };
}
