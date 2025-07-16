# Bazarr subtitle management configuration
{ config, ... }:

{
  # Enable Bazarr subtitle management
  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/var/lib/bazarr";
    listenPort = config.beanlab.ports.bazarr;
    extraArgs = [
      "-c" "${config.services.bazarr.dataDir}"
      "-p" "${toString config.beanlab.ports.bazarr}"
    ];
  };
} 