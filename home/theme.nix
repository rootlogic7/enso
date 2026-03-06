{ config, pkgs, ... }:

{
  # Die zentrale Kontrollstation für dein gesamtes System-Ricing
  catppuccin = {
    enable = true;       # Themt automatisch ALLE unterstützten Programme
    flavor = "mocha";    
    accent = "mauve";    
  };

  # ICHTIG: Hier aktivieren wir die Programme "richtig" über Home-Manager.
  # Dadurch werden ihre Konfigurationsdateien generiert und Catppuccin kann seine Magie wirken.
  programs = {
    waybar.enable = true;
    # NEU: Fuzzel mit ricy Layout
    fuzzel = {
      enable = true;
      settings = {
        main = {
          # Gleiche Schriftart wie in deiner Waybar!
          font = "JetBrainsMono Nerd Font:size=14"; 
          terminal = "${pkgs.foot}/bin/foot";
          
          # Layout anpassen (etwas breiter und luftiger)
          width = 45;
          lines = 8;
          line-height = 28;
          horizontal-pad = 20;
          vertical-pad = 20;
          inner-pad = 10;
        };
        border = {
          # Passt perfekt zu deinem Hyprland 'rounding = 8' und 'border_size = 2'
          radius = 8;
          width = 2;
        };
      };
    };
    bat.enable = true;
    zellij.enable = true;

    rofi.enable = true;
  };

  services = {
    mako.enable = true;
  };

  # GTK-Theming für Wayland-Fenster (Dateimanager etc.)
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
    };
  };
}
