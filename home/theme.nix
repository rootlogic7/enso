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
    fuzzel.enable = true;
    bat.enable = true;
    zellij.enable = true;
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
