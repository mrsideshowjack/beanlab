# Radarr movie management configuration
{ config, ... }:

{
  # Enable Radarr movie management
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/var/lib/radarr";
  };
} 