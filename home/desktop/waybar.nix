# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

let
  theme = config.horizon.theme;
in {
  # Die JSONC-Config laden wir weiterhin aus deiner Datei, das ist übersichtlicher
  xdg.configFile."waybar/config".source = ./waybar/config.jsonc;

  programs.waybar = {
    enable = true;
    
    # Home-Manager baut uns die style.css automatisch aus diesem String!
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "${theme.ui.font}", monospace;
          font-size: 13px; /* Ein Tick größer für bessere Lesbarkeit mit Glow */
          min-height: 0;
      }

      /* Die Hauptleiste wird unsichtbar */
      window#waybar {
          background-color: transparent;
      }

      /* Die Module werden zu abgerundeten, leuchtenden Pillen */
      .modules-left, .modules-center, .modules-right {
          background-color: rgba(5, 5, 20, ${theme.ui.opacity});
          border: 1px solid #${theme.colors.pink};
          border-radius: 12px;
          margin: 10px 15px 0px 15px; /* Abstand nach oben und zu den Seiten (Floating) */
          box-shadow: 0px 0px 15px rgba(255, 0, 170, 0.4); /* Pinker Neon-Glow */
      }

      tooltip {
          background: #${theme.colors.bg};
          border: 1px solid #${theme.colors.cyan};
          border-radius: ${toString theme.ui.rounding}px;
          box-shadow: 0px 0px 10px rgba(0, 229, 255, 0.4);
      }

      #workspaces button {
          padding: 0 12px;
          color: #4a3b69; /* Dunkles, gedämpftes Lila */
      }

      #workspaces button.active {
          color: #${theme.colors.cyan};
          font-weight: bold;
          text-shadow: 0px 0px 8px #${theme.colors.cyan}; /* Text-Glow! */
      }

      #clock, #battery, #network, #pulseaudio, #tray {
          padding: 0 15px;
          color: #${theme.colors.fg};
          text-shadow: 0px 0px 5px #${theme.colors.fg};
      }

      /* Spezifische Modul-Farben zur Auflockerung */
      #battery.charging { 
          color: #${theme.colors.orange}; 
          text-shadow: 0px 0px 8px #${theme.colors.orange}; 
      }
      #battery.warning:not(.charging) { 
          color: #ff0055; 
          text-shadow: 0px 0px 8px #ff0055; 
      }
    '';
  };
}
