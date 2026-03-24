# hosts/nova/waybar.nix
{ config, pkgs, lib, ... }:

let
  modules = config.horizon.desktop.waybar.modules;
  theme = config.horizon.theme;
in {
  programs.waybar = {
    # Home-Manager akzeptiert hier eine Liste für Multi-Monitor-Setups!
    settings = [
      # 1. Die Portable-Bar (Immer auf dem Laptop-Screen eDP-1)
      ({
        name = "portable-top";
        output = [ "eDP-1" ];
        layer = "top";
        position = "top";
        height = 24;
        spacing = 4;
        modules-left = [ "custom/nixos" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "idle_inhibitor" "tray" "clock" "custom/power" ];
      } // modules)
      
      ({
        name = "portable-bottom";
        output = [ "eDP-1" ];
        layer = "top";
        position = "bottom";
        height = 24;
        modules-left = [ "network" ];
        modules-center = [ ];
        modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ];
      } // modules)

      # 2. Die Docked-Bar (Wird NUR geladen, wenn der Monitor DP-6 aktiv ist)
      ({
        name = "docked-top";
        output = [ "DP-6" ];
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "custom/nixos" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "idle_inhibitor" "tray" "network" "cpu" "memory" "pulseaudio" "clock" ];
      } // modules)
    ];

    # Nova-spezifisches Styling (Du kannst hier per output stylen!)
    style = ''
      * { border: none; font-family: "${theme.ui.font}"; font-size: 11px; min-height: 0; }
      window#waybar { background-color: #${theme.colors.bg}; color: #${theme.colors.fg}; }
      
      /* Spezifisches Styling für die obere und untere Leiste */
      window#waybar.portable-top, window#waybar.docked-top { border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_primary}; }
      window#waybar.portable-bottom { border-top: ${toString theme.ui.border_size}px solid #${theme.colors.accent_tertiary}; }

      #workspaces button { padding: 2px 6px; color: #${theme.colors.inactive_border}; }
      #workspaces button.active { color: #${theme.colors.accent_primary}; font-weight: bold; }
      /* ... Restliche Standard-Styles aus dem alten Switcher hier einfügen ... */
    '';
  };
}
