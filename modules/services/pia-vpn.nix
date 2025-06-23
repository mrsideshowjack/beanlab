{ config, lib, pkgs, ... }:

{
  # Use native NixOS OpenVPN with PIA .ovpn file
  services.openvpn.servers = {
    pia = {
      autoStart = false; # We'll start it manually after processing
      
      # Dummy config - will be replaced at runtime
      config = ''
        # This will be replaced by the setup service
      '';
    };
  };

  # Create auth file and process .ovpn file
  systemd.services.openvpn-pia-setup = {
    description = "Setup PIA OpenVPN configuration and auth";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      echo "Setting up PIA OpenVPN configuration..."
      
      # Extract credentials from existing env file and create auth file
      if [ -f /etc/nixos/pia-credentials.env ]; then
        source /etc/nixos/pia-credentials.env
        echo "$PIA_USER" > /etc/nixos/auth.txt
        echo "$PIA_PASS" >> /etc/nixos/auth.txt
        chmod 600 /etc/nixos/auth.txt
        echo "Created auth file"
      else
        echo "PIA credentials file not found!"
        exit 1
      fi
      
      # Process the .ovpn file to use our auth file
      if [ -f /etc/nixos/japan-aes-128-cbc-udp-dns.ovpn ]; then
        # Copy .ovpn file and modify it to use our auth file
        cp /etc/nixos/japan-aes-128-cbc-udp-dns.ovpn /etc/nixos/pia-processed.ovpn
        
        # Replace auth-user-pass line to point to our auth file
        sed -i 's/^auth-user-pass$/auth-user-pass \/etc\/nixos\/auth.txt/' /etc/nixos/pia-processed.ovpn
        
        chmod 600 /etc/nixos/pia-processed.ovpn
        echo "Processed .ovpn configuration"
      else
        echo "PIA .ovpn file not found at /etc/nixos/japan-aes-128-cbc-udp-dns.ovpn"
        exit 1
      fi
    '';
  };
  
  # Custom OpenVPN service using the processed config
  systemd.services.openvpn-pia-vpn = {
    description = "PIA OpenVPN connection";
    after = [ "openvpn-pia-setup.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    requires = [ "openvpn-pia-setup.service" ];
    serviceConfig = {
      Type = "exec";
      Restart = "always";
      RestartSec = "5";
      ExecStart = "${pkgs.openvpn}/bin/openvpn --config /etc/nixos/pia-processed.ovpn";
      CapabilityBoundingSet = "CAP_IPC_LOCK CAP_NET_ADMIN CAP_NET_RAW CAP_SETGID CAP_SETUID CAP_SYS_CHROOT CAP_DAC_OVERRIDE CAP_AUDIT_WRITE";
      LimitNPROC = 10;
      DeviceAllow = "/dev/net/tun rw";
      # Add network namespace and device access
      PrivateNetwork = false;
      DevicePolicy = "strict";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Ensure services wait for VPN
  systemd.services.jellyfin.after = [ "openvpn-pia-vpn.service" ];
  systemd.services.immich-server.after = [ "openvpn-pia-vpn.service" ];
} 