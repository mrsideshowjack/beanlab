# Centralized variables for Beanlab configuration
{ lib, ... }:

{
  options.beanlab = {
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