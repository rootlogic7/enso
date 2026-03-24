# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

{
  # Wir erstellen eine eigene Option, um die Module DRY an die Hosts weiterzugeben
  options.horizon.desktop.waybar.modules = lib.mkOption {
    type = lib.types.attrs;
    description = "Zentrale Definition aller Waybar-Module für Horizon";
    default = {
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
  };

  config = {
    programs.waybar = {
      enable = true;
      # Überlässt Systemd das Starten/Stoppen von Waybar passend zu Hyprland
      systemd.enable = true; 
    };
  };
}
