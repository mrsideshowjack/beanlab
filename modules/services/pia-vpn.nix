# PIA VPN configuration
{ config, lib, pkgs, ... }:

{
  # Enable PIA VPN service
  services.pia = {
    enable = true;
    # Use credentials file instead of hardcoded values
    authUserPassFile = "/etc/nixos/pia-credentials.txt";
  };

  # PIA Credentials Management Service
  # systemd.services.pia-credentials = {
  #   description = "Create PIA credentials file";
  #   wantedBy = [ "multi-user.target" ];
  #   before = [ "openvpn-*.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  };

  # Install the PIA CLI tool
  environment.systemPackages = [ pkgs.pia ];

  # # Basic firewall rules - only apply if firewall is enabled
  # networking.firewall = lib.mkIf config.networking.firewall.enable {
  #   allowedUDPPorts = [ 1198 ]; # Common PIA VPN port
  #   allowedTCPPorts = [ 22 ];   # SSH
    
  #   # Allow established connections and DNS
  #   extraCommands = ''
  #     # Allow established connections
  #     iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  #     iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      
  #     # Allow DNS queries
  #     iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
  #     iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
      
  #     # Allow HTTPS for Comin
  #     iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
  #   '';
  # };
} 