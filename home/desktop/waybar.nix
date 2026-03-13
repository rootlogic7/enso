# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;

  # 1. GEMEINSAME MODULE
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
  mkTopBar = output: { name = "topbar"; layer = "top"; position = "top"; height = 24; spacing = 4; inherit output; modules-left = [ "custom/nixos" "hyprland/workspaces" ]; modules-center = [ "hyprland/window" ]; modules-right = [ "idle_inhibitor" "tray" "clock" "custom/power" ]; } // modules;
  mkBottomBar = output: { name = "bottombar"; layer = "top"; position = "bottom"; height = 24; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ]; } // modules;
  
  mkTopBarQuasarMain = output: mkTopBar output;
  mkBottomBarQuasar = output: { name = "bottombar-quasar"; layer = "top"; position = "bottom"; height = 24; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "pulseaudio" ]; } // modules;
  mkTopBarQuasarSec = output: { name = "topbar-quasar-sec"; layer = "top"; position = "top"; height = 24; spacing = 4; inherit output; modules-left = [ "network" ]; modules-center = [ ]; modules-right = [ "cpu" "memory" "pulseaudio" ]; } // modules;

  # 3. DIE MODI GENERIEREN
  modeLaptop      = [ (mkTopBar "eDP-1") (mkBottomBar "eDP-1") ];
  modeDocking     = [ (mkTopBar "DP-6")  (mkBottomBar "eDP-1") ];
  modeDockingOnly = [ (mkTopBar "DP-6")  (mkBottomBar "DP-6")  ];
  modeQuasarSingle = [ (mkTopBar "DP-1") (mkBottomBarQuasar "DP-1") ];
  modeQuasarDual   = [ (mkTopBar "DP-1") (mkTopBarQuasarSec "HDMI-A-1") ];

  # 4. DAS INTELLIGENTE SWITCHER-SKRIPT (Bleibt erhalten für Monitor-Erkennung)
  barSwitcher = pkgs.writeShellScriptBin "statusbar-switcher" ''
    ${pkgs.procps}/bin/pkill waybar || true
    sleep 0.5
    
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name' || echo "")
    MONITORS_FLAT=" $(echo $MONITORS | tr '\n' ' ') "
    
    CONF_DIR="${config.home.homeDirectory}/.config/waybar"
    
    if [[ "$MONITORS_FLAT" == *" DP-1 "* && "$MONITORS_FLAT" == *" HDMI-A-1 "* ]]; then
      CFG="$CONF_DIR/config-quasar-dual"
    elif [[ "$MONITORS_FLAT" == *" DP-1 "* ]]; then
      CFG="$CONF_DIR/config-quasar-single"
    elif [[ "$MONITORS_FLAT" == *" DP-6 "* && "$MONITORS_FLAT" == *" eDP-1 "* ]]; then
      CFG="$CONF_DIR/config-docking"
    elif [[ "$MONITORS_FLAT" == *" DP-6 "* ]]; then
      CFG="$CONF_DIR/config-docking-only"
    else
      CFG="$CONF_DIR/config-laptop"
    fi

    ${pkgs.waybar}/bin/waybar -c "$CFG" -s "$CONF_DIR/style.css" > /dev/null 2>&1 &
    disown
  '';

in {
  home.packages = [
    barSwitcher
    pkgs.jq
  ];

  # Schreibe die verschiedenen Monitor-Layouts in den XDG-Ordner
  xdg.configFile."waybar/config-laptop".text = builtins.toJSON modeLaptop;
  xdg.configFile."waybar/config-docking".text = builtins.toJSON modeDocking;
  xdg.configFile."waybar/config-docking-only".text = builtins.toJSON modeDockingOnly;
  xdg.configFile."waybar/config-quasar-single".text = builtins.toJSON modeQuasarSingle;
  xdg.configFile."waybar/config-quasar-dual".text = builtins.toJSON modeQuasarDual;

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    
    # 5. DAS NEUTRALE CSS
    style = ''
      * {
          border: none;
          border-radius: ${toString theme.ui.rounding}px;
          font-family: "${theme.ui.font}", "${theme.ui.font_propo}", monospace;
          font-size: 11px;
          min-height: 0;
      }

      window#waybar {
          /* Transparenz wird später über Rgba im Skin geregelt, hier nutzen wir den hex-fallback */
          background-color: #${theme.colors.bg};
          color: #${theme.colors.fg};
      }

      window#waybar.topbar {
          border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_primary};
      }

      window#waybar.bottombar {
          border-top: ${toString theme.ui.border_size}px solid #${theme.colors.accent_tertiary};
      }

      #workspaces button, #clock, #battery, #network, #pulseaudio, 
      #backlight, #memory, #cpu, #tray, #idle_inhibitor, #custom-power, #custom-nixos {
          padding: 2px 6px;
          margin: 2px 4px;
          color: #${theme.colors.fg};
      }

      #window {
          font-size: 11px;
          padding: 2px 6px;
          margin: 2px 4px;
          color: #${theme.colors.accent_tertiary};
          font-weight: bold;
      }

      #workspaces button { 
          color: #${theme.colors.inactive_border};
      }
      
      #workspaces button.active { 
          color: #${theme.colors.accent_primary}; 
          font-weight: bold;
      }

      #battery.charging { color: #${theme.colors.term.green}; }
      #battery.warning:not(.charging) { color: #${theme.colors.term.yellow}; }
      #battery.critical:not(.charging) { color: #${theme.colors.term.red}; }
    '';
  };
}
