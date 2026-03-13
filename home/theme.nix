# home/theme.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.theme;
in {
  # 1. Das "Schema" für alle künftigen Skins
  options.horizon.theme = {
    enable = mkEnableOption "Enable Horizon Theme Engine";

    ui = {
      font = mkOption { type = types.str; default = "monospace"; description = "System Default Font"; };
      font_propo = mkOption { type = types.str; default = "sans-serif"; };
      opacity = mkOption { type = types.str; default = "1.0"; };
      rounding = mkOption { type = types.int; default = 0; };
      border_size = mkOption { type = types.int; default = 1; };
      blur_size = mkOption { type = types.int; default = 0; };
    };

    colors = {
      bg = mkOption { type = types.str; default = "111111"; };
      fg = mkOption { type = types.str; default = "eeeeee"; };
      cursor = mkOption { type = types.str; default = "ffffff"; };
      
      accent_primary = mkOption { type = types.str; default = "555555"; };
      accent_secondary = mkOption { type = types.str; default = "777777"; };
      accent_tertiary = mkOption { type = types.str; default = "999999"; };
      inactive_border = mkOption { type = types.str; default = "333333"; };

      # Terminal Farben (Neutrales Fallback)
      term = {
        black   = mkOption { type = types.str; default = "000000"; };
        red     = mkOption { type = types.str; default = "cc0000"; };
        green   = mkOption { type = types.str; default = "00cc00"; };
        yellow  = mkOption { type = types.str; default = "cccc00"; };
        blue    = mkOption { type = types.str; default = "0000cc"; };
        magenta = mkOption { type = types.str; default = "cc00cc"; };
        cyan    = mkOption { type = types.str; default = "00cccc"; };
        white   = mkOption { type = types.str; default = "cccccc"; };
      };
    };
  };

  # 2. Globale Basis-Dienste (ohne spezifisches Styling)
  # 2. Globale Basis-Dienste (Direkt an das neutrale Schema gekoppelt)
  config = mkIf cfg.enable {
    
    # Neutraler Fallback-Cursor
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    # Basis-Dienste (ohne UI)
    programs.bat.enable = true;
    programs.zellij.enable = true;

    # --- FUZZEL ---
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${cfg.ui.font}:size=12";
          terminal = "${pkgs.foot}/bin/foot";
          width = 45;
          lines = 8;
          line-height = 24;
          horizontal-pad = 20;
          vertical-pad = 20;
          inner-pad = 10;
        };
        border = {
          radius = cfg.ui.rounding;
          width = cfg.ui.border_size;
        };
        # Farben direkt aus dem Schema laden (fuzzel erwartet RGBA Hex-Strings, 
        # wir hängen also z.B. 'ff' für volle Deckkraft oder 'dd' für Transparenz an)
        colors = {
          background = "${cfg.colors.bg}dd";
          text = "${cfg.colors.fg}ff";
          match = "${cfg.colors.accent_primary}ff";
          selection = "${cfg.colors.inactive_border}cc";
          selection-text = "${cfg.colors.accent_tertiary}ff";
          selection-match = "${cfg.colors.accent_secondary}ff";
          border = "${cfg.colors.accent_primary}ff";
        };
      };
    };

    # --- MAKO ---
    services.mako = {
      enable = true;
      settings = {
        # UI-Werte
        border-radius = cfg.ui.rounding;
        border-size = cfg.ui.border_size;
      
        # Farben direkt aus dem Schema laden (Mako erwartet klassische #Hex-Werte)
        background-color = "#${cfg.colors.bg}ee";
        text-color = "#${cfg.colors.fg}";
        border-color = "#${cfg.colors.accent_primary}";
      };
    };
  };
}
