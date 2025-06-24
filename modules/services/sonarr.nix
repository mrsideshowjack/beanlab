# Sonarr TV show management configuration
{ config, ... }:

{
  # Enable Sonarr TV show management
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/var/lib/sonarr";
  };
} 