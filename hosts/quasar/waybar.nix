# hosts/quasar/waybar.nix
{ config, pkgs, lib, ... }:

let
  modules = config.horizon.desktop.waybar.modules;
  theme = config.horizon.theme;
in {
  programs.waybar = {
    settings = [
      # Hauptmonitor
      ({
        name = "main-top";
        output = [ "DP-1" ];
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "custom/nixos" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "tray" "network" "cpu" "memory" "pulseaudio" "clock" "custom/power" ];
      } // modules)

      # Zweitmonitor (Nur rudimentäre Infos)
      ({
        name = "sec-top";
        output = [ "HDMI-A-1" ];
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "clock" ];
      } // modules)
    ];

    # Quasar-spezifisches Styling
    style = ''
      * { border: none; font-family: "${theme.ui.font}"; font-size: 11px; }
      window#waybar { background-color: #${theme.colors.bg}; color: #${theme.colors.fg}; border-radius: ${toString theme.ui.rounding}px; }
      window#waybar.main-top { border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_secondary}; }
      #workspaces button.active { color: #${theme.colors.accent_primary}; }
    '';
  };
}
