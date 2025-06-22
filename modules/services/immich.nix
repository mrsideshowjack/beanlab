# Immich photo management configuration
{ config, ... }:

{
  # Enable Immich photo management
  services.immich = {
    enable = true;
    port = config.beanlab.ports.immich;
    host = "0.0.0.0";  # Listen on all interfaces
    mediaLocation = "/storage/pool/pictures";
  };
} 