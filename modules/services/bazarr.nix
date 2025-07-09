# Bazarr subtitle management configuration
{ config, pkgs, ... }:

let
  cfg = config.beanlab;
in
{
  # Create a custom Bazarr service since it's not available in NixOS 25.05
  systemd.services.bazarr = {
    description = "Bazarr subtitle management";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "bean";
      Group = "users";
      ExecStart = "${pkgs.bazarr}/bin/bazarr --no-browser --data=/var/lib/bazarr --port=${toString cfg.ports.bazarr} --config=/var/lib/bazarr";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Create data directory
  systemd.tmpfiles.rules = [
    "d /var/lib/bazarr 0755 bean users - -"
  ];

  # Open firewall port
  networking.firewall.allowedTCPPorts = [ cfg.ports.bazarr ];

  # Install Bazarr package
  environment.systemPackages = [ pkgs.bazarr ];
} 