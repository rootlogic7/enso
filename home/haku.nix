{ pkgs, ... }:

{
  # Grundlegende Home-Manager-Einstellungen
  home = {

    # home.stateVersion
    stateVersion = "25.11";

    username = "haku";
    homeDirectory = "/home/haku";
  

    # home.packages
    packages = with pkgs; [
      # Wayland & Desktop
      hyprpaper
      hypridle
    
      # File Explorer
      yazi

      # Web & Development
      firefox
      wget
      curl
    ];
  };

  programs = {
    home-manager.enable = true;

    # Deine neue deklarative Git-Konfiguration
    git = {
      enable = true;

      settings = {
        user.name = "haku";
        user.email = "haku@horizon.net";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    # GPG konfigurieren
    gpg.enable = true;

    # pass konfigurieren
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]); # Optional: OTP-Support
    };

    # Browserpass (Die Brücke zwischen 'pass' und Firefox)
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  # Den GPG-Agent als Service starten (fragt nach dem Passwort zum Entschlüsseln)
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-rofi;
    # NEU: Passwort für 8 Stunden (28800 Sekunden) im Cache behalten
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
  };

  imports = [
    ./shell/default.nix
    ./desktop/default.nix
    ./theme.nix
  #   ./programs/default.nix
  ];
}
