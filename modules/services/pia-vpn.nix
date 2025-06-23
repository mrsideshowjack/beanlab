{ config, lib, pkgs, ... }:

{
  services.pia-vpn = {
    enable = true;
    certificateFile = ./ca.rsa.4096.crt;
    environmentFile = ./pia-credentials.env;

    environment = {
      PIA_PREFERRED_REGION = "japan";
    };
    
    # Configure network to route all traffic through VPN
    networkConfig = ''
      [Match]
      Name = wg0

      [Network]
      Description = WireGuard PIA network interface
      Address = ''${peerip}/32

      [RoutingPolicyRule]
      To = ''${wg_ip}/32
      Priority = 1000

      # Port forwarding service exception
      [RoutingPolicyRule]
      To = ''${meta_ip}/32
      Priority = 1000

      # Route all other traffic through VPN
      [RoutingPolicyRule]
      To = 0.0.0.0/0
      Priority = 2000
      Table = 42

      [Route]
      Destination = 0.0.0.0/0
      Table = 42
    '';
    
    postUp = ''
      echo "VPN is up and routing all traffic through wg0"
    '';
    
    # Optional: Enable port forwarding if needed for services
    portForward = {
      enable = false; # Set to true if you need port forwarding for services like Transmission
      script = ''
        echo "Forwarded port: $port"
        # Add your port forwarding script here if needed
        # Example for transmission:
        # ${pkgs.transmission_4}/bin/transmission-remote --authenv --port $port || true
      '';
    };
  };

  # Ensure services that need VPN wait for it to be up
  # systemd.services.jellyfin.after = [ "pia-vpn.service" ];
  # systemd.services.immich-server.after = [ "pia-vpn.service" ];
  
  # Optional: Bind services to VPN (uncomment if you want services to stop when VPN goes down)
  # systemd.services.jellyfin.bindsTo = [ "pia-vpn.service" ];
  # systemd.services.immich-server.bindsTo = [ "pia-vpn.service" ];
} 