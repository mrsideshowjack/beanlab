# Homepage dashboard services configuration
{ config }:

let
  cfg = config.beanlab;
  domain = cfg.network.serverDomain;
in
[
  {
    "Media Services" = [
      {
        "Jellyfin" = {
          icon = "jellyfin";
          href = "http://${domain}:${toString cfg.ports.jellyfin}";
          description = "Media Server - Movies, TV Shows, Music";
          siteMonitor = "http://${domain}:${toString cfg.ports.jellyfin}";
          widget = {
            type = "jellyfin";
            url = "http://${domain}:${toString cfg.ports.jellyfin}";
            key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
          };
        };
      }
      {
        "Immich" = {
          icon = "immich";
          href = "http://${domain}:${toString cfg.ports.immich}";
          description = "Photo Management & Backup";
          siteMonitor = "http://${domain}:${toString cfg.ports.immich}";
          widget = {
            type = "immich";
            url = "http://${domain}:${toString cfg.ports.immich}";
            key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
          };
        };
      }
    ];
  }
  {
    "System Monitoring" = [
      {
        "System Storage" = {
          icon = "mdi-harddisk";
          href = "#";
          description = "Storage Pool: /storage/pool";
          widget = {
            type = "disk";
            path = "/storage/pool";
          };
        };
      }
      {
        "System Resources" = {
          icon = "mdi-memory";
          href = "#";
          description = "CPU, Memory, Network";
          widget = {
            type = "resources";
            cpu = true;
            memory = true;
            disk = "/storage/pool";
            cputemp = true;
            tempmin = 0;
            tempmax = 100;
            uptime = true;
          };
        };
      }
    ];
  }
] 