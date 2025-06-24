# Radarr movie management configuration
{ config, ... }:

{
  # Enable Radarr movie management
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/storage/pool/media/.radarr";
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /storage/pool/media 0755 bean users - -"
    "d /storage/pool/media/movies 0755 bean users - -" 
    "d /storage/pool/media/.radarr 0755 bean users - -"
  ];
} 