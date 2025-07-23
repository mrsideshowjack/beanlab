# Homepage dashboard main configuration
{ config, ... }:

let
  cfg = config.beanlab;
in
{
  # Enable glances for system monitoring
  services.glances.enable = true;
  
  # Enable Homepage dashboard
  services.homepage-dashboard = {
    enable = true;
    listenPort = cfg.ports.homepage;
    openFirewall = true;
    
    allowedHosts = "localhost:${toString cfg.ports.homepage},127.0.0.1:${toString cfg.ports.homepage},${cfg.network.serverIP}:${toString cfg.ports.homepage},${cfg.network.serverDomain}:${toString cfg.ports.homepage}";
    
    # Load environment variables from secrets file
    environmentFile = "/etc/beanlab/secrets/homepage.env";
    
    # Import settings from separate file
    settings = import ./settings.nix { inherit config; };
    
    # Import services from separate file  
    services = import ./services.nix { inherit config; };
    
    # Import widgets from separate file
    widgets = import ./widgets.nix { inherit config; };
    
    # Custom CSS for Homepage
    customCSS = ''
      :root {
        --bg-color: rgba(0, 0, 0, 0.5);
      }
    '';
    
    # Custom JS for Homepage (if needed later)
    customJS = builtins.readFile ./custom.js;
    
    # Import bookmarks
    bookmarks = [
      {
        "Quick Links" = [
          {
            "Router" = [
              {
                abbr = "RT";
                href = "http://192.168.1.1";
                description = "Network Router";
              }
            ];
          }
          {
            "Beanlab SSH" = [
              {
                abbr = "SSH";
                href = "ssh://bean@${cfg.network.serverDomain}";
                description = "SSH to Beanlab Server";
              }
            ];
          }
        ];
      }
    ];
  };
} 