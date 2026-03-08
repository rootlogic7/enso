{ pkgs, osConfig, ... }:

{
  # Alle CLI-Tools, die du primär in der Shell nutzt
  home.packages = with pkgs; [
    eza
    zoxide
    ripgrep
    fd
    bottom
    # fastfetch wurde hier entfernt, da es unten als eigenes Programm geladen wird
    starship
  ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 1;
          left = 2;
          right = 4;
        };
        # Wir zwingen Fastfetch, eine Datei zu lesen
        type = "file";
        # pkgs.writeText erstellt eine Datei im Nix-Store und gibt den Pfad zurück
        source = "${pkgs.writeText "sun-logo.txt" ''
         $1⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠠⣾⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⠋⠁⠀⠀⠈⠹⣿⣿⣿⣿⣿⡿⠋⠀⠀⠈⠻⣿⣿⣿⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⣿⣿⣿⣿⠃⠀⠀⠀⣴⣶⡄⢹⣿⣿⣿⣿⠃⢰⣶⡄⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⣿⣿⣿⣿⡆⠀⠀⠀⠹⠿⠁⣸⣿⣿⣿⣿⡀⠘⡿⠃⠀⢀⣿⣿⣿⡆⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣯⣹⣿⣷⣤⣾⣿⣿⣿⣿⣿⣿⣃⣀⣀⣀⣀⠀
             ⠀⠾⠿⠟⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠋⠉⠉⠋⠀
             ⠠⣤⣤⣶⡶⠿⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠛⠛⠷⣶⡄
             ⠀⠀⠉⢀⣠⣶⠾⠟⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠛⠳⢶⣦⣄⡀⠀⠀
              ⠀⠀⠀⠟⠋⠁⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠁⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀
             ⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
             ⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
              ⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
             ⠀ ⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
             ⠀⠀ ⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
        ''}";
        color = { "1" = "magenta"; };
      };
      
      display = {
        separator = " 󰁔 ";
        color = {
          # "red" wird zu Neon-Pink, "cyan" bleibt Neon-Cyan
          keys = "red";
          title = "cyan";
        };
      };

      modules = [
        "break"
        {
          type = "title";
          color = {
            # "yellow" wird durch foot.nix zu deinem Neon-Orange!
            user = "yellow";
            at = "white";
            host = "cyan";
          };
        }
        "break"
        { type = "os"; key = "OS   "; }
        { type = "kernel"; key = "KRNL "; }
        { type = "packages"; key = "PKGS "; }
        { type = "wm"; key = "WM   "; }
        { type = "terminal"; key = "TERM "; }
        { type = "shell"; key = "SHLL "; }
        { type = "uptime"; key = "UP   "; }
        "break"
        { type = "colors"; symbol = "circle"; }
      ];
    };
  };

  programs = {
    # Nushell Konfiguration
    nushell = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        ls = "eza";
        tree = "eza --tree";

        # Git
        gs = "git status";
        ga = "git add";
        gc = "git commit -m";
        gp = "git push";

        # Nixos
        nix-switch = "sudo nixos-rebuild switch --flake .#${osConfig.networking.hostName}";
        nix-update = "nix flake update";
      };

      # Keine manuellen Init-Skripte mehr nötig für Zoxide/Starship!
      # Fastfetch wird hier beim Start ausgeführt
      extraConfig = ''
        $env.config = {
          show_banner: false,
        }
        # Fastfetch beim Start anzeigen
        fastfetch
      '';
    };

    # Zoxide (Smarter cd-Ersatz)
    zoxide = {
      enable = true;
      enableNushellIntegration = true; 
    };

    # Starship Prompt
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
