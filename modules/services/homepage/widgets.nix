# Homepage dashboard widgets configuration
{ config }:

[
  # Date and time widget
  {
    datetime = {
      text_size = "xl";
      format = {
        timeStyle = "short";
        dateStyle = "short";
        hourCycle = "h23";
      };
    };
  }
  
  # VPN Detection widget - detects PIA vs direct connection
  {
    customapi = {
      url = "https://ipinfo.io/json";
      refreshInterval = 30000; # 30 seconds
      mappings = [
        {
          label = "External IP";
          field = "ip";
        }
        {
          label = "Connection Type";
          field = "org";
          format = "{{org.includes('Datacamp Limited') || org.includes('AS212238') || hostname.includes('datapacket.com') ? '🔒 VPN (PIA)' : '🌐 Direct (NTT)'}}";
        }
        {
          label = "ISP";
          field = "org";
        }
      ];
    };
  }
  
  # System resources widget to show VPN interface
  {
    resources = {
      expanded = true;
      cpu = true;
      memory = true;
      disk = "/";
      cputemp = true;
      uptime = true;
    };
  }
] 