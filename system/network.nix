{ ... }:

{
  # 📶 NetworkManager kümmert sich um WLAN, LAN und VPNs
  networking.networkmanager.enable = true;

  # 🛡️ Firewall aktivieren
  networking.firewall.enable = true;
  # SSH-Port (22) öffnen, damit du dich von außen auf kaze einloggen kannst
  networking.firewall.allowedTCPPorts = [ 22 ];

  # 🔑 SSH-Server (OpenSSH) konfigurieren
  services.openssh = {
    enable = true;
    settings = {
      # Sicherheit geht vor: Kein Root-Login von außen
      PermitRootLogin = "no";
      # Passwort-Login vorerst erlauben. Wenn du später SSH-Keys nutzt, 
      # kannst du das für maximale Sicherheit auf "no" setzen.
      PasswordAuthentication = true;
    };
  };
}
