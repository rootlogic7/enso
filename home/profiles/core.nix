# home/profiles/core.nix
{ pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    yazi
    wget
    curl
    ssh-to-age
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "haku";
        user.email = "haku@horizon.net";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_main";
          identitiesOnly = true;
        };
        "gitea" = {
          hostname = "192.168.178.10";
          user = "git";
          port = 2222; # WICHTIG: Der gemappte Container-Port
          identityFile = "~/.ssh/id_ed25519_main";
          identitiesOnly = true;
        };
        "pi" = {
          hostname = "192.168.178.10";
          user = "root";
          identityFile = "~/.ssh/id_ed25519_main";
          identitiesOnly = true;
        };
      };
    };

    gpg.enable = true;
    
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };
  };

  services.gpg-agent = {
    enable = true;
    # Für Server nutzen wir standardmäßig die CLI-Passwortabfrage (Curses)
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
  };

  # Automatische Generierung des SOPS Age-Keys aus dem SSH-Key
  home.activation.generateAgeKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/.ssh/id_ed25519_main" ] && [ ! -f "$HOME/.config/sops/age/keys.txt" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/sops/age"
      $DRY_RUN_CMD ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519_main" > "$HOME/.config/sops/age/keys.txt"
      $DRY_RUN_CMD chmod 600 "$HOME/.config/sops/age/keys.txt"
    fi
  '';

  imports = [
    inputs.nixvim.homeModules.nixvim
    ../shell/default.nix
    ../programs/nixvim.nix
  ];
}
