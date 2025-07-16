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
      '';
    };
  };
}


# Ensure services wait for VPN (only torrent-related services need VPN)
  systemd.services.deluged.after = [ "openvpn-pia.service" ];
  systemd.services.delugeweb.after = [ "openvpn-pia.service" ];
  systemd.services.sonarr.after = [ "openvpn-pia.service" ];
  systemd.services.radarr.after = [ "openvpn-pia.service" ];
  systemd.services.prowlarr.after = [ "openvpn-pia.service" ];