# Jellyfin media server configuration
{ config, ... }:

{
  # Enable Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";  # Use users group to match existing setup
  };
} 