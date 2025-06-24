# Sonarr TV show management configuration
{ config, ... }:

{
  # Enable Sonarr TV show management
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/storage/pool/Video/.sonarr";
  };

  # Create necessary directories (using existing Video/TV structure)
  systemd.tmpfiles.rules = [
    "d /storage/pool/Video/.sonarr 0755 bean users -"
  ];
} 