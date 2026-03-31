{ pkgs, osConfig, ... }:

{
  # Alle CLI-Tools, die du primär in der Shell nutzt
  home.packages = with pkgs; [
    eza
    ripgrep
    fd
    bottom
    d2             # Modernes, schnelles Diagramming (perfekt für Nushell-Skripte)
    plantuml       # Klassische komplexe UMLs
    mermaid-cli    # Mermaid Graphen im Terminal rendern
    glow           # Markdown Dokumente hübsch in 'foot' lesen
    taskwarrior3
  ];

  programs = {
    # System-Informationen beim Shell-Start (jetzt sauber aktiviert)
    fastfetch.enable = true;

    # Yazi Dateimanager mit CWD-Support beim Beenden
    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Mächtige Autovervollständigung für Nushell
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
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

        # Neovin
        v = "nvim";

        # Nixos
        nix-switch = "sudo nixos-rebuild switch --flake .#${osConfig.networking.hostName}";
        nix-update = "nix flake update";
        rebuild-pi = "ansible-playbook -i inventory.yml pi.yml";
      };

      # fastfetch
      extraConfig = ''
        $env.config.show_banner = false
        fastfetch
      '';
    };

    # Zoxide
    zoxide = {
      enable = true;
      enableNushellIntegration = true; 
    };

    # Starship
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Direnv
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
