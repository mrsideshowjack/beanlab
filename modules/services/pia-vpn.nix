{ config, lib, pkgs, ... }:

let
  cfg = config.beanlab;
in
{
  # Basic PIA VPN configuration for testing
  services.pia = {
    enable = true;
    authUserPassFile = "/etc/nixos/pia-credentials.txt";
  };

  # Create credentials file from environment variables
  systemd.services.pia-credentials = {
    description = "Create PIA credentials file";
    wantedBy = [ "multi-user.target" ];
    before = [ "openvpn-*.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ -f /etc/nixos/pia-credentials.env ]; then
        source /etc/nixos/pia-credentials.env
        echo "$PIA_USER" > /etc/nixos/pia-credentials.txt
        echo "$PIA_PASS" >> /etc/nixos/pia-credentials.txt
        chmod 600 /etc/nixos/pia-credentials.txt
        echo "Created PIA credentials file"
      else
        echo "PIA credentials file not found!"
        exit 1
      fi
    '';
  };

  # Install the PIA CLI tool
  environment.systemPackages = [ pkgs.pia ];

  # Basic firewall rules - allow VPN and essential services
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 1198 ]; # Common PIA VPN port
    allowedTCPPorts = [ 22 ];   # SSH
    
    # Allow established connections and DNS
    extraCommands = ''
      # Allow established connections
      iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      
      # Allow DNS queries
      iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
      iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
      
      # Allow HTTPS for Comin
      iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
    '';
  };
} 