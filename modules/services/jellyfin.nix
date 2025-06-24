# Jellyfin media server configuration
{ config, ... }:

{
  # Enable Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "multimedia";  # Use multimedia group for shared access
  };
} 