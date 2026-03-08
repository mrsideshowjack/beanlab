{ config, ... }:

let
  cfg = config.beanlab;
in
{
  # Persistent storage for Bookshelf configuration
  systemd.tmpfiles.rules = [
    "d /var/lib/bookshelf 0755 root root - -"
  ];

  virtualisation.oci-containers.containers."bookshelf" = {
    image = "ghcr.io/pennydreadful/bookshelf:hardcover-v0.4.20.129";

    # Expose the web UI on the same port Readarr used
    ports = [
      "${toString cfg.ports.readarr}:8787"
    ];

    # Basic environment; container uses its own internal user
    environment = {
      TZ = "Asia/Tokyo";
      PUID = "1000";
      PGID = "100";
    };

    volumes = [
      "/var/lib/bookshelf:/config"
      "/storage/pool:/storage/pool"
    ];
  };
}

