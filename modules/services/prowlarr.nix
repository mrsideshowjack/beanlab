# Prowlarr movie management configuration
{ config, ... }:

{
  # Enable Prowlarr movie management
  services.prowlarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/var/lib/prowlarr";
  };
} 