# system/razer.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.hardware.razer;

  # Wir definieren die neue Quelle einmal zentral für alle 3 Komponenten
  razerVersion = "3.12.0";
  razerSrc = pkgs.fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${razerVersion}";
    hash = "sha256-Sgn+7DABsTnRTx/lh/++JPmfsQ7dM6frkyzG0F5k2gA="; # Absichtlich falscher Hash
  };

in {
  options.horizon.hardware.razer = {
    enable = mkEnableOption "Enable OpenRazer daemon and Polychromatic frontend";
  };

  config = mkIf cfg.enable {
    
    # 1. Daemon und Library tief in den Python-Paketen patchen
    nixpkgs.overlays = [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pyFinal: pyPrev: {
            openrazer = pyPrev.openrazer.overrideAttrs (old: {
              version = razerVersion;
              src = razerSrc;
            });
            openrazer-daemon = pyPrev.openrazer-daemon.overrideAttrs (old: {
              version = razerVersion;
              src = razerSrc;
            });
          })
        ];
      })
    ];

    # 2. Das Kernel-Modul für deinen System-Kernel patchen
    boot.kernelPackages = pkgs.linuxPackages.extend (linuxFinal: linuxPrev: {
      openrazer = linuxPrev.openrazer.overrideAttrs (old: {
        version = razerVersion;
        src = razerSrc;
      });
    });

    # 3. Standard-Aktivierung
    hardware.openrazer.enable = true;
    users.users.haku.extraGroups = [ "openrazer" ];

    environment.systemPackages = with pkgs; [
      polychromatic
    ];
  };
}
