# hosts/nova/kanshi.nix
{ config, pkgs, ... }:

let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  # Der magische Befehl, der Waybar nach dem Umbau neu lädt
  restartWaybar = "systemctl --user restart waybar.service"; 
in {
  home-manager.users.haku = {
    services.kanshi.profiles = {
      
      "portable" = {
        outputs = [ { criteria = "eDP-1"; status = "enable"; } ];
        exec = [
          "${hyprctl} dispatch moveworkspacetomonitor name:System eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor name:Server eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor 1 eDP-1"
          restartWaybar
        ];
      };

      "docked" = {
        outputs = [
          { criteria = "eDP-1"; status = "enable"; }
          { criteria = "DP-6"; status = "enable"; }
        ];
        exec = [
          "${hyprctl} dispatch moveworkspacetomonitor name:System DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor name:Server DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 1 eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor 2 eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor 3 eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor 4 eDP-1"
          "${hyprctl} dispatch moveworkspacetomonitor 5 eDP-1"
          restartWaybar
        ];
      };

      "docked-only" = {
        outputs = [
          { criteria = "eDP-1"; status = "disable"; }
          { criteria = "DP-6"; status = "enable"; }
        ];
        exec = [
          "${hyprctl} dispatch moveworkspacetomonitor name:System DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor name:Server DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 1 DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 2 DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 3 DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 4 DP-6"
          "${hyprctl} dispatch moveworkspacetomonitor 5 DP-6"
          restartWaybar
        ];
      };
      
    };
  };
}
