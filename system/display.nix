{ pkgs, inputs, ... }:

{
  # Wir importieren das sysc-greet NixOS-Modul direkt aus dem Flake-Input
  imports = [ inputs.sysc-greet.nixosModules.default ];

  # 🌀 Hyprland systemweit aktivieren
  # Das stellt sicher, dass alle Systemvariablen für Wayland richtig gesetzt sind
  programs.hyprland.enable = true;

  # 🚪 sysc-greet als Display Manager (Greeter) konfigurieren
  services.sysc-greet = {
    enable = true;
    # Da Hyprland unser Haupt-Compositor ist, weisen wir sysc-greet an, 
    # ebenfalls Hyprland zu nutzen, um die TUI-Oberfläche zu rendern.
    compositor = "hyprland"; 
  };

  # 🔐 Polkit aktivieren
  # Unverzichtbar für GUI-Anwendungen, die gelegentlich Root-Rechte brauchen 
  # (z. B. Laufwerke einhängen oder bestimmte Systemeinstellungen ändern).
  security.polkit.enable = true;

  # 🔤 Schriftarten (Fonts)
  # Für sysc-greet (und später Waybar, Terminal etc.) brauchen wir Nerd-Fonts,
  # damit die ASCII-Art und Icons perfekt gerendert werden.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
