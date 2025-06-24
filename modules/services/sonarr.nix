# Sonarr TV show management configuration
{ config, ... }:

{
  # Enable Sonarr TV show management
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "multimedia";
    dataDir = "/storage/pool/media/.sonarr";
    
    # Sonarr configuration
    settings = {
      server = {
        port = config.beanlab.ports.sonarr;
      };
    };
  };

  # Create necessary directories  
  systemd.tmpfiles.rules = [
    "d /storage/pool/media 0755 bean users -"
    "d /storage/pool/media/tv 0755 bean users -"
    "d /storage/pool/media/.sonarr 0755 bean users -"
  ];
} 