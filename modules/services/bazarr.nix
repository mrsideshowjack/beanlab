# Bazarr subtitle management configuration
{ config, ... }:

{
  # Enable Bazarr subtitle management
  services.bazarr = {
    enable = true;
    openFirewall = true;
  };
} 