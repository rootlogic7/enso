# home/desktop/kanshi.nix
{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    # Startet Kanshi automatisch, sobald Hyprland hochgefahren ist
    systemdTarget = "hyprland-session.target"; 
    
    # Profile bleiben leer, da sie hostspezifisch injiziert werden
    profiles = {}; 
  };
}
