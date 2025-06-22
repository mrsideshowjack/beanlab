# Jellyfin media server configuration
{ config, ... }:

{
  # Enable Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "bean";  # Run as your user to avoid permission issues
  };
} 