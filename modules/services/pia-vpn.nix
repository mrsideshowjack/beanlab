{ config, lib, pkgs, ... }:

{
  # Simple OpenVPN configuration following Reddit comment pattern
  services.openvpn.servers = {
    pia = {
      autoStart = true;
      
      # Configuration based on .ovpn file
      config = ''
        client
        dev tun
        proto udp
        remote japan.privacy.network 1198
        resolv-retry infinite
        nobind
        persist-key
        persist-tun
        cipher aes-128-cbc
        auth sha1
        tls-client
        remote-cert-tls server

        # Use auth file instead of embedding credentials
        auth-user-pass /etc/nixos/auth.txt
        compress
        verb 1
        reneg-sec 0
        
        # Use extracted certificate files
        ca /etc/nixos/ca.pem
        # crl-verify /etc/nixos/crl.pem  # Disabled due to ASN.1 parsing errors

        disable-occ
        
        # Route all traffic through VPN
        redirect-gateway def1
        
        # Use PIA DNS
        dhcp-option DNS 209.222.18.222
        dhcp-option DNS 209.222.18.218
      '';
    };
  };

  # Create auth file from credentials
  systemd.services.openvpn-pia-auth = {
    description = "Create PIA OpenVPN auth file";
    wantedBy = [ "openvpn-pia.service" ];
    before = [ "openvpn-pia.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ -f /etc/nixos/pia-credentials.env ]; then
        source /etc/nixos/pia-credentials.env
        echo "$PIA_USER" > /etc/nixos/auth.txt
        echo "$PIA_PASS" >> /etc/nixos/auth.txt
        chmod 600 /etc/nixos/auth.txt
        echo "Created auth file for OpenVPN"
      else
        echo "PIA credentials file not found!"
        exit 1
      fi
    '';
  };

  # Ensure services wait for VPN
  systemd.services.jellyfin.after = [ "openvpn-pia.service" ];
  systemd.services.immich-server.after = [ "openvpn-pia.service" ];
} 