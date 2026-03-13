{ config, ... }:

let
  cfg = config.beanlab;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/home-assistant 0755 root root - -"
  ];

  virtualisation.oci-containers.containers."home-assistant" = {
    image = "ghcr.io/home-assistant/home-assistant:stable";

    environment = {
      TZ = config.time.timeZone;
    };

    volumes = [
      "/var/lib/home-assistant:/config"
      "/run/dbus:/run/dbus:ro"
      "/dev/serial/by-id:/dev/serial/by-id:ro"
    ];

    extraOptions = [
      "--network=host"
      "--privileged"
      "--device=/dev/ttyACM0:/dev/ttyACM0"
    ];
  };

  networking.firewall.allowedTCPPorts = [ cfg.ports.homeAssistant ];
}
