# PIA VPN configuration
{ config, lib, pkgs, ... }:

{
  # Enable PIA VPN service
  services.pia = {
    enable = true;
    # Use credentials file instead of hardcoded values
    authUserPassFile = "/etc/nixos/pia-credentials.txt";
  };

  # Install the PIA CLI tool
  environment.systemPackages = [ pkgs.pia ];
} 