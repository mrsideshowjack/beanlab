# Radarr movie management configuration
{ config, ... }:

{
  # Enable Radarr movie management
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/storage/pool/Video/.radarr";
  };

  # Create necessary directories (using existing Video/film structure)
  systemd.tmpfiles.rules = [
    "d /storage/pool/Video/.radarr 0755 bean users - -"
  ];
} 