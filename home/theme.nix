{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.theme;
in {
  # 1. Wir definieren unsere Theme-Variablen (Die "Engine")
  options.horizon.theme = {
    enable = mkEnableOption "Enable Custom Horizon Theme Engine";

    colors = {
      # Basis
      bg = mkOption { type = types.str; default = "050514"; description = "Extrem dunkles Mitternachtsblau/Violett"; };
      fg = mkOption { type = types.str; default = "00e5ff"; description = "Neon Cyan (Text leuchtet)"; };
      inactive = mkOption { type = types.str; default = "110b29"; };

      # Synthwave Terminal Palette (Die 8 Grundfarben)
      black   = mkOption { type = types.str; default = "050514"; }; # Gleich wie bg
      red     = mkOption { type = types.str; default = "ff0055"; }; # Neon Rot/Pink (dein altes 'pink')
      green   = mkOption { type = types.str; default = "00ffcc"; }; # Neon Mint
      yellow  = mkOption { type = types.str; default = "ff5500"; }; # Neon Orange (dein altes 'orange')
      blue    = mkOption { type = types.str; default = "00e5ff"; }; # Neon Cyan (dein altes 'cyan')
      magenta = mkOption { type = types.str; default = "b800ff"; }; # Deep Purple
      cyan    = mkOption { type = types.str; default = "00ffff"; }; # Light Cyan
      white   = mkOption { type = types.str; default = "e0d8ea"; }; # Off-White für echten Text

      # Semantische Aliase (DRY: Wir verweisen auf die Palette)
      orange = mkOption { type = types.str; default = "ff5500"; }; # Alias für dein Accent
      pink   = mkOption { type = types.str; default = "ff00aa"; }; # Spezifisches helles Pink
    };

    ui = {
      font = mkOption { type = types.str; default = "DepartureMono Nerd Font Mono"; };
      font_propo = mkOption { type = types.str; default = "DepartureMono Nerd Font Propo"; };
      opacity = mkOption { type = types.str; default = "0.75"; };
      rounding = mkOption { type = types.int; default = 4; };
      border_size = mkOption { type = types.int; default = 2; };
      blur_size = mkOption { type = types.int; default = 8; };
    };
  };

  # 2. Globale Tools direkt mit diesen Werten konfigurieren
  config = mkIf cfg.enable {
    
    # Cursor
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    # Fuzzel (Launcher) mit Theme-Variablen
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
        colors = {
          # Hex-Werte + Alpha-Kanal (z.B. 'dd' für leichte Transparenz)
          background = "${cfg.colors.bg}dd";
          text = "${cfg.colors.fg}ff";
          match = "${cfg.colors.pink}ff";
          selection = "${cfg.colors.inactive}cc";
          selection-text = "${cfg.colors.cyan}ff";
          selection-match = "${cfg.colors.orange}ff";
          border = "${cfg.colors.pink}ff";
        };
        border = {
          radius = cfg.ui.rounding;
          width = cfg.ui.border_size;
        };
      };
    };

    # Basis-Dienste
    programs.bat.enable = true;
    programs.zellij.enable = true;
    services.mako = {
      settings = {
        enable = true;
        backgroundColor = "#${cfg.colors.bg}ee";
        textColor = "#${cfg.colors.fg}";
        borderColor = "#${cfg.colors.pink}";
        borderRadius = cfg.ui.rounding;
        borderSize = cfg.ui.border_size;
      };
    };
  };
}
