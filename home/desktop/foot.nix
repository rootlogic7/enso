{ config, pkgs, ... }:

let
  theme = config.horizon.theme;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "nu";
        pad = "15x15";
        font = "${theme.ui.font}:size=12";
      };
      
      colors = {
        alpha = theme.ui.opacity;
        background = theme.colors.bg;
        foreground = theme.colors.fg;
        
        # Terminal Farben (0-7) strikt aus der Theme-Engine geladen
        regular0 = theme.colors.black;
        regular1 = theme.colors.red;
        regular2 = theme.colors.green;
        regular3 = theme.colors.yellow; # Unser Orange
        regular4 = theme.colors.blue;   # Unser Cyan
        regular5 = theme.colors.magenta;
        regular6 = theme.colors.cyan;
        regular7 = theme.colors.white;
        
        # Für helle Farben (bright 8-15) können wir die gleichen Werte wiederverwenden 
        # oder in der theme.nix später noch spezifische 'bright'-Variablen definieren.
        bright0 = theme.colors.inactive; # Etwas helleres Schwarz
        bright1 = theme.colors.pink;     # Helles Pink statt Rot
        bright2 = theme.colors.green;
        bright3 = theme.colors.yellow;
        bright4 = theme.colors.blue;
        bright5 = theme.colors.magenta;
        bright6 = theme.colors.cyan;
        bright7 = theme.colors.white;
      };
    };
  };
}
