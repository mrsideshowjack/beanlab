{ config, lib, pkgs, ... }:

let
  cfg = config.beanlab;
in
{
  # Configure local DNS resolution for .lab domains
  services.resolved = {
    enable = true;
    domains = [ "~lab" ]; # Handle .lab domains locally
    fallbackDns = [ 
      cfg.network.routerIP     # Router DNS 
      cfg.dns.piaDNS           # PIA DNS
      cfg.dns.fallbackDNS      # Fallback DNS
    ];
    extraConfig = ''
      DNS=${cfg.network.routerIP}
      Domains=~lab
      DNSStubListener=yes
    '';
  };

  # Add local hosts entries for lab services using variables
  networking.hosts = {
    "${cfg.network.serverIP}" = [ 
      cfg.network.serverDomain
      "jellyfin.${cfg.network.serverDomain}"
      "immich.${cfg.network.serverDomain}"
    ];
  };

  # Ensure local DNS works with VPN
  networking.networkmanager.dns = "systemd-resolved";
} 