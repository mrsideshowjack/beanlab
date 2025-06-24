# Homepage dashboard services configuration
{ config }:

let
  cfg = config.beanlab;
  domain = cfg.network.serverDomain;
  glancesPort = toString config.services.glances.port;
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
          # widget = {
          #   type = "immich";
          #   url = "http://${domain}:${toString cfg.ports.immich}";
          #   key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
          # };
        };
      }
    ];
  }
  {
    "Network & VPN" = [
      {
        "PIA VPN" = {
          icon = "mdi-vpn";
          href = "#";
          description = "VPN Status & Connection";
          widget = {
            type = "customapi";
            url = "https://ipinfo.io/json";
            refreshInterval = 30000;
            mappings = [
              {
                label = "Status";
                field = "org";
                format = "{{org.includes('Datacamp Limited') ? '🟢 Connected' : '🔴 Disconnected'}}";
              }
              {
                label = "Location";
                field = "city";
              }
              {
                label = "Public IP";
                field = "ip";
              }
            ];
          };
        };
      }
    ];
  }
  {
    "System Monitoring" = [
      {
        "System Resources" = {
          icon = "mdi-memory";
          href = "#";
          description = "CPU, Memory, Disk & Network";
          widget = {
            type = "glances";
            url = "http://localhost:${glancesPort}";
            metric = "info";
            chart = false;
            version = 4;
          };
        };
      }
      {
        "System Info" = {
          icon = "mdi-information-outline";
          href = "#";
          description = "Host Information";
          widget = {
            type = "glances";
            url = "http://localhost:${glancesPort}";
            metric = "info";
            chart = false;
            version = 4;
          };
        };
      }
      {
        "CPU Temperature" = {
          icon = "mdi-thermometer";
          href = "#";
          description = "CPU Thermal Monitoring";
          widget = {
            type = "glances";
            url = "http://localhost:${glancesPort}";
            metric = "sensor:Package id 0";
            chart = false;
            version = 4;
          };
        };
      }
      {
        "Active Processes" = {
          icon = "mdi-cog";
          href = "#";
          description = "Running Processes";
          widget = {
            type = "glances";
            url = "http://localhost:${glancesPort}";
            metric = "process";
            chart = false;
            version = 4;
          };
        };
      }
    ];
  }
] 