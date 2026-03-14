# skins/custom.nix
{ config, lib, pkgs, ... }:

{
  # Wir aktivieren die Theme-Engine, die wir in home/theme.nix gebaut haben
  horizon.theme.enable = true;

  horizon.theme.ui = {
    # Schriften (Achte darauf, dass die Schriftarten auf dem System installiert sind)
    font = "DepartureMono Nerd Font Mono";
    font_propo = "DepartureMono Nerd Font Propo";
    
    # Allgemeine UI-Werte
    opacity = "0.85";     # Transparenz für Foot-Terminal (0.0 bis 1.0)
    rounding = 6;         # Eckenabrundung für Hyprland, Waybar, Fuzzel, Mako
    border_size = 2;      # Rahmendicke
    blur_size = 8;        # Stärke des Hintergrund-Blurs in Hyprland
  };

  horizon.theme.colors = {
    # --- BASIS-FARBEN (Hex-Werte ohne #) ---
    bg = "0f0f14";        # Haupthintergrund (z.B. sehr dunkles Grau/Blau)
    fg = "e0e0e0";        # Haupttextfarbe
    cursor = "ffffff";    # Cursor-Farbe (falls du später eigene Cursor renderst)
    
    # --- AKZENT-FARBEN ---
    # Diese werden für Fensterrahmen, Waybar-Linien, Mako-Ränder etc. genutzt
    accent_primary = "ff0055";    # Z.B. dein kräftiges Pink/Rot
    accent_secondary = "00e5ff";  # Z.B. dein Cyan
    accent_tertiary = "ffaa00";   # Z.B. ein warmes Orange/Gelb
    inactive_border = "202030";   # Rahmenfarbe für inaktive Fenster
    
    # --- TERMINAL FARBEN (0-7) ---
    # Diese bestimmen, wie Konsolen-Apps (wie Neovim, htop, ls) aussehen
    term = {
      black   = "1a1a24"; # regular0
      red     = "ff3366"; # regular1
      green   = "33ff99"; # regular2
      yellow  = "ffcc00"; # regular3
      blue    = "3399ff"; # regular4
      magenta = "cc33ff"; # regular5
      cyan    = "00ffff"; # regular6
      white   = "e0e0e0"; # regular7
    };
  };

  # --- OPTIONAL: EIGENE THEME-SPEZIFISCHE PAKETE ---
  # Du kannst hier sogar Programme oder Wallpaper definieren, die NUR geladen werden,
  # wenn dieses spezifische Theme aktiv ist!
  
  # home-manager.users.haku = { pkgs, ... }: {
  #   home.packages = with pkgs; [ 
  #     # z.B. ein spezielles Icon-Theme
  #   ];
  #   
  #   # Dein Hintergrundbild per swaybg starten
  #   wayland.windowManager.hyprland.settings.exec-once = [
  #     "${pkgs.swaybg}/bin/swaybg -i /pfad/zu/deinem/wallpaper.jpg -m fill"
  #   ];
  # };
}
