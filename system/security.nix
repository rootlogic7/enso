# system/security.nix
{ config, pkgs, ... }:

{
  # olkit (Ermöglicht unprivilegierten Prozessen, Admin-Rechte anzufragen)
  security.polkit.enable = true;

  # Passwort-Management & Keyring (für 'pass', GPG und System-Passwörter)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # (Optional, aber empfohlen) Rtkit für Realtime-Scheduling (wichtig für Audio/Pipewire)
  security.rtkit.enable = true;

  # Sudo-Sicherheit (Standardmäßig gut, aber hier kannst du später feintunen)
  security.sudo = {
    enable = true;
    execWheelOnly = true; # Nur Mitglieder der 'wheel' Gruppe dürfen sudo ausführen
  };
}
