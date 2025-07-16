# Minimal PIA VPN configuration using OpenVPN
{ config, lib, pkgs, ... }:

{
  # Simple OpenVPN configuration for testing
  services.openvpn.servers = {
    pia = {
      autoStart = true;
      
      # Basic configuration matching the processed OVPN
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

        auth-user-pass /etc/nixos/auth.txt
        compress
        verb 1
        reneg-sec 0
        
        # Use the existing certificate files
        ca /etc/nixos/ca.pem
        
        # Disable features that might cause issues
        disable-occ
        
        # Basic routing for testing
        redirect-gateway def1
        
        # DNS settings
        dhcp-option DNS ${config.beanlab.dns.piaDNS}
        dhcp-option DNS ${config.beanlab.dns.fallbackDNS}

        # Kill switch configuration
        script-security 2
        up /etc/openvpn/up.sh
        down /etc/openvpn/down.sh
      '';
    };
  };

  # Create up/down scripts for kill switch
  environment.etc = {
    "openvpn/up.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        # Get the VPN server IP
        VPN_IP=$(${pkgs.iproute2}/bin/ip route get japan.privacy.network | grep -oP 'via \K[^ ]+' || echo "")
        if [ -n "$VPN_IP" ]; then
          # Save the gateway IP for the VPN server route
          echo "$VPN_IP" > /tmp/vpn_gateway
        fi
        
        # Remove default route but keep VPN server route
        ${pkgs.iproute2}/bin/ip route del default || true
        if [ -n "$VPN_IP" ]; then
          ${pkgs.iproute2}/bin/ip route add japan.privacy.network via $VPN_IP || true
        fi
        
        # Add VPN route
        ${pkgs.iproute2}/bin/ip route add default dev tun0 || true
        echo "Kill switch enabled - routes updated for VPN"
      '';
      mode = "0755";
    };
    "openvpn/down.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        # Remove the default route
        ${pkgs.iproute2}/bin/ip route del default || true
        
        # Restore VPN server route if gateway is saved
        if [ -f "/tmp/vpn_gateway" ]; then
          VPN_IP=$(cat /tmp/vpn_gateway)
          ${pkgs.iproute2}/bin/ip route add japan.privacy.network via $VPN_IP || true
        fi
        
        echo "OpenVPN connection down - traffic blocked by kill switch"
      '';
      mode = "0755";
    };
  };

  # Ensure services wait for VPN (only torrent-related services need VPN)
  systemd.services = {
    deluged.after = [ "openvpn-pia.service" ];
    delugeweb.after = [ "openvpn-pia.service" ];
    sonarr.after = [ "openvpn-pia.service" ];
    radarr.after = [ "openvpn-pia.service" ];
    prowlarr.after = [ "openvpn-pia.service" ];
  };
}
  