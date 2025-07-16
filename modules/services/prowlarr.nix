# Prowlarr indexer management configuration
{ config, ... }:

{
  # Enable Prowlarr indexer management
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
} 