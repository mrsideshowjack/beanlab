{ config, lib, pkgs, ... }:

{
  # Use native NixOS OpenVPN with PIA .ovpn file
  services.openvpn.servers = {
    pia = {
      autoStart = true;
      
      # Use the .ovpn file directly
      config = builtins.readFile "/etc/nixos/japan-aes-128-cbc-udp-dns.ovpn" + ''
        
        # Override auth-user-pass to use our auth file
        auth-user-pass /etc/nixos/auth.txt
      '';
    };
  };

  # Create auth file from existing credentials
  systemd.services.openvpn-pia-setup = {
    description = "Setup PIA OpenVPN auth file";
    wantedBy = [ "openvpn-pia.service" ];
    before = [ "openvpn-pia.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Extract credentials from existing env file and create auth file
      if [ -f /etc/nixos/pia-credentials.env ]; then
        source /etc/nixos/pia-credentials.env
        echo "$PIA_USER" > /etc/nixos/auth.txt
        echo "$PIA_PASS" >> /etc/nixos/auth.txt
        chmod 600 /etc/nixos/auth.txt
      else
        echo "PIA credentials file not found!"
        exit 1
      fi
    '';
  };

  # Ensure services wait for VPN
  # systemd.services.jellyfin.after = [ "openvpn-pia.service" ];
  # systemd.services.immich-server.after = [ "openvpn-pia.service" ];
} 