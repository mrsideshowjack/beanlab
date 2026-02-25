# Readarr book management configuration
{ config, ... }:

{
  # Enable Readarr book management
  services.readarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/var/lib/readarr";
  };
} 