# Centralized variables for Beanlab configuration
{ lib, ... }:

{
  options.beanlab = {

    system = {
      repoURL = lib.mkOption {
        type = lib.types.str;
        default = "https://github.com/mrsideshowjack/beanlab.git";
        description = "Repository URL";
      };
    };

    network = {
      serverIP = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.69";
        description = "Server IP address";
      };
      
      serverDomain = lib.mkOption {
        type = lib.types.str;
        default = "bean.lab";
        description = "Server domain name";
      };
      
      routerIP = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.1";
        description = "Router IP address";
      };
    };

    dns = {
      piaDNS = lib.mkOption {
        type = lib.types.str;
        default = "10.0.0.242";
        description = "PIA DNS server (basic DNS)";
      };
      
      fallbackDNS = lib.mkOption {
        type = lib.types.str;
        default = "1.1.1.1";
        description = "Fallback DNS server (Cloudflare)";
      };
    };

    ports = {
      homepage = lib.mkOption {
        type = lib.types.int;
        default = 3000;
        description = "Homepage dashboard port";
      };
      
      jellyfin = lib.mkOption {
        type = lib.types.int;
        default = 8096;
        description = "Jellyfin media server port";
      };
      
      immich = lib.mkOption {
        type = lib.types.int;
        default = 2283;
        description = "Immich photo management port";
      };
    };
  };
} 