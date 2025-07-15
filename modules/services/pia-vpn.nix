# Minimal PIA VPN configuration using OpenVPN
{ config, lib, pkgs, ... }:

{
  # Simple OpenVPN configuration for testing
  services.openvpn.servers = {
    pia = {
      autoStart = true;
      
      # Use the existing processed config file
      config = ''
        config /etc/nixos/pia-processed.ovpn
        
        # Override the auth file path to use our existing credentials
        auth-user-pass /etc/nixos/pia-credentials.txt
        
        # Basic routing for testing
        redirect-gateway def1
        
        # DNS settings
        dhcp-option DNS ${config.beanlab.dns.piaDNS}
        dhcp-option DNS ${config.beanlab.dns.fallbackDNS}
      '';
    };
  };
} 


#  # Ensure services wait for VPN (only torrent-related services need VPN)
#   # Note: Only route torrent traffic through VPN, keep media servers local
#   systemd.services.deluged.after = [ "openvpn-pia.service" ];
#   systemd.services.delugeweb.after = [ "openvpn-pia.service" ];
#   systemd.services.sonarr.after = [ "openvpn-pia.service" ];
#   systemd.services.radarr.after = [ "openvpn-pia.service" ];
#   systemd.services.prowlarr.after = [ "openvpn-pia.service" ];