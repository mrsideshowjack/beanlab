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
  
  # VPN Status widget - cleaner layout
  {
    customapi = {
      url = "https://ipinfo.io/json";
      refreshInterval = 30000; # 30 seconds
      mappings = [
        {
          label = "VPN Status";
          field = "org";
          format = "{{org.includes('Datacamp Limited') || org.includes('AS212238') ? '🟢 Connected' : '🔴 Disconnected'}}";
        }
        {
          label = "External IP";
          field = "ip";
        }
      ];
    };
  }
] 