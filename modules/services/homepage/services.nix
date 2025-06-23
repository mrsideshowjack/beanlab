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
    "Network & VPN" = [
      {
        "PIA VPN Status" = {
          icon = "mdi-vpn";
          href = "#";
          description = "Private Internet Access Japan";
          widget = {
            type = "customapi";
            url = "https://ipinfo.io/json";
            refreshInterval = 30000;
            mappings = [
              {
                label = "Public IP";
                field = "ip";
              }
              {
                label = "ISP/Provider";
                field = "org";
              }
              {
                label = "VPN Status";
                field = "org";
                format = "{{org.includes('Datacamp Limited') || org.includes('AS212238') || hostname.includes('datapacket.com') ? '🟢 PIA Connected' : '🔴 Direct Connection'}}";
              }
              {
                label = "Hostname";
                field = "hostname";
              }
            ];
          };
        };
      }
      {
        "VPN Tunnel Status" = {
          icon = "mdi-tunnel-outline";
          href = "#";
          description = "Local VPN Interface Status";
          widget = {
            type = "glances";
            url = "http://localhost:${glancesPort}";
            metric = "network:tun0";
            chart = false;
            version = 4;
          };
        };
      }
      {
        "OpenVPN Service" = {
          icon = "mdi-shield-check";
          href = "#";
          description = "OpenVPN PIA Service Status";
          server = "localhost";
          container = "openvpn-pia";
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
            type = "resources";
            cpu = true;
            memory = true;
            disk = "/storage/pool";
            cputemp = true;
            tempmin = 0;
            tempmax = 100;
            uptime = true;
            units = "metric";
            refresh = 3000;
            diskUnits = "bytes";
            network = true;
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