# hosts/nova/waybar.nix
{ config, pkgs, lib, ... }:

let
  # 1. Globale Theme- und Modul-Basis laden
  theme = config.horizon.theme;
  globalModules = config.horizon.desktop.waybar.modules;

  # 2. Nova-spezifische Modul-Anpassungen (Deep Merge)
  # Hier nutzen wir lib.recursiveUpdate statt dem einfachen // Operator.
  # So können wir z.B. dem Batterie-Modul neue Eigenschaften geben, 
  # ohne die globalen Icons oder Schwellenwerte zu überschreiben.
  novaModules = lib.recursiveUpdate globalModules {
    
    # Beispiel-Erweiterung: Detailliertere Akku-Anzeige für den Laptop
    "battery" = {
      format-alt = "{time} {icon}"; # Zeigt beim Klicken die verbleibende Zeit an
    };

    # Beispiel-Erweiterung: Backlight-Scroll-Speed anpassen
    "backlight" = {
      scroll-step = 5.0;
    };
  };

  # 3. Definition der einzelnen Leisten (Bars)
  
  # 3.1 Portable Top (Laptop-Bildschirm, oben)
  portableTop = {
    name = "portable-top";
    output = [ "eDP-1" ];
    layer = "top";
    position = "top";
    height = 24;
    spacing = 6;
    modules-left = [ "hyprland/workspaces#system" "hyprland/workspaces#server" "hyprland/workspaces" ];
    modules-center = [ "custom/context" "hyprland/window" ];
    modules-right = [ "custom/display_mode" "idle_inhibitor" "tray" "clock" "custom/power" ];
  } // novaModules;

  # 3.2 Portable Bottom (Laptop-Bildschirm, unten)
  portableBottom = {
    name = "portable-bottom";
    output = [ "eDP-1" ];
    layer = "top";
    position = "bottom";
    height = 24;
    modules-left = [ "network" ];
    modules-center = [ ];
    modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "battery" ];
  } // novaModules;

  # 3.3 Docked Top (Externer Monitor)
  dockedTop = {
    name = "docked-top";
    output = [ "DP-6" ]; 
    layer = "top";
    position = "top";
    height = 24;
    modules-left = [ "hyprland/workspaces#system" "hyprland/workspaces#server" "hyprland/workspaces" ];
    modules-center = [ "custom/context" "hyprland/window" ];
    modules-right = [ "idle_inhibitor" "tray" "network" "cpu" "memory" "pulseaudio" "clock" ];
  } // novaModules;

in {
  programs.waybar = {
    # 4. Zusammenbau der Konfiguration
    # Das Array ist jetzt wunderbar übersichtlich!
    settings = [
      portableTop
      portableBottom
      dockedTop
    ];

    # 5. Styling
    style = ''
      * { 
        border: none;
        font-family: "${theme.ui.font}"; 
        font-size: 11px; 
        min-height: 0; 
      }
      
      window#waybar { 
        background-color: #${theme.colors.bg}; 
        color: #${theme.colors.fg};
      }
      
      window#waybar.portable-top, 
      window#waybar.docked-top { 
        border-bottom: ${toString theme.ui.border_size}px solid #${theme.colors.accent_primary};
      }
      
      window#waybar.portable-bottom { 
        border-top: ${toString theme.ui.border_size}px solid #${theme.colors.accent_tertiary};
      }
      
      /* Workspaces */
      /* --- WORKSPACES GENERAL --- */
      #workspaces {
        padding: 0 4px;
      }
      
      #workspaces button { 
        padding: 0;
        min-width: 28px;

        background: transparent;
        background-color: transparent;
        box-shadow: none;
        text-shadow: none;
        border: none;
        border-radius: ${toString theme.ui.rounding}px; 
        transition: all 0.2s ease;

        /* ZUSTAND 1: LEER */
        color: #${theme.colors.inactive_border}; 
        font-size: 13px;
      }
      
      #workspaces button:hover {
        color: #${theme.colors.accent_secondary};
        background: transparent;
        background-color: transparent;
      }
      
      #workspaces button:not(.empty):not(.active) {
        color: #${theme.colors.accent_tertiary};
      }

      #workspaces button.active { 
        color: #${theme.colors.accent_primary};
        font-weight: bold;
      }

      /* --- SPECIAL WORKSPACES (System & Server) --- */
      #workspaces.system {
        padding-right: 0;
        margin-top: 4px;
        margin-bottom: 4px;
      }

      #workspaces.server {
        padding-left: 0;
        border-right: 1px solid #${theme.colors.accent_tertiary};
        margin-top: 4px;    
        margin-bottom: 4px;
        margin-right: 8px; 
        padding-right: 8px;
      }

      #workspaces.system button,
      #workspaces.server button {
        color: #${theme.colors.inactive_border};
        font-size: 14px; 
        min-width: 28px;
      }
      
      #workspaces.system button.active,
      #workspaces.server button.active {
        color: #${theme.colors.accent_primary}; 
      }
      
      /* --- USER/HOST CONTEXT PILLE --- */
      #custom-context {
        padding: 0 12px;
        margin-right: 8px;
        margin-top: 4px;    
        margin-bottom: 4px;
        border-radius: ${toString theme.ui.rounding}px;
        font-weight: bold;
        min-width: 140px;
      }

      /* Zustand 1: Lokal (Normaler Zustand) */
      #custom-context.local {
        background-color: transparent; 
        color: #${theme.colors.accent_tertiary};
        border: 1px solid #${theme.colors.accent_tertiary};
      }

      /* Zustand 2: SSH Verbindung (Alarm / Highlight!) */
      /* Sobald du auf einen Pi per SSH gehst, springt diese Pille ins Auge */
      #custom-context.ssh {
        background-color: #${theme.colors.accent_primary}; 
        color: #${theme.colors.bg}; /* Dunkler Text auf leuchtender Akzentfarbe */
        border: 1px solid #${theme.colors.accent_primary};
      }

      /* --- WINDOW TITLE (Mitte) --- */
      #window {
        min-width: 400px;
        padding: 0 12px;
        margin-top: 4px;    
        margin-bottom: 4px;
        background-color: #${theme.colors.accent_tertiary};
        color: #${theme.colors.bg};
        border-radius: ${toString theme.ui.rounding}px;
        font-weight: normal;
      }

      #window.empty {
        color: transparent;
        background-color: transparent;
      }

      /* --- DISPLAY MODE INDICATOR --- */
      #custom-display_mode {
        padding: 0 10px;
        margin-left: 8px;
        border-radius: ${toString theme.ui.rounding}px;
        font-size: 15px; /* Die Icons dürfen gerne etwas präsenter sein */
        transition: all 0.3s ease;
      }

      /* Szenario A: Unauffällig, wenn man den Laptop normal nutzt */
      #custom-display_mode.portable {
        color: #${theme.colors.accent_secondary};
        background-color: transparent;
      }

      /* Szenario B: Highlight! Beide Bildschirme aktiv */
      #custom-display_mode.docked {
        color: #${theme.colors.accent_primary};
        background-color: #${theme.colors.inactive_border};
      }

      /* Szenario C: Alternativer Akzent, da der Laptop zugeklappt ist */
      #custom-display_mode.docked-only {
        color: #${theme.colors.bg};
        background-color: #${theme.colors.accent_tertiary};
      }
    '';
  };
}
