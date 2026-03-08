{ config, ... }:

{
  # Persistent storage for rreading-glasses database
  systemd.tmpfiles.rules = [
    "d /var/lib/rreading-glasses 0750 root root - -"
    "d /var/lib/rreading-glasses/db 0750 root root - -"
  ];

  virtualisation.oci-containers.containers."rreading-glasses-db" = {
    image = "docker.io/library/postgres:17";
    

    environment = {
      POSTGRES_USER = "rreading-glasses";
      POSTGRES_DB = "rreading-glasses";
      PUID = "1000";
      PGID = "100";
    };

    # Load POSTGRES_PASSWORD (and any other secrets) from:
    #   /var/lib/rreading-glasses/env
    # as documented in the README.
    environmentFiles = [ "/var/lib/rreading-glasses/env" ];

    volumes = [
      "/var/lib/rreading-glasses/db:/var/lib/postgresql/data"
    ];
  };

  virtualisation.oci-containers.containers."rreading-glasses" = {
    image = "docker.io/blampe/rreading-glasses:hardcover";

    # Run the main server binary with verbose logging
    entrypoint = "/main";
    cmd = [ "serve" "--verbose" ];

    environment = {
      POSTGRES_HOST = "rreading-glasses-db";
      POSTGRES_DATABASE = "rreading-glasses";
      POSTGRES_USER = "rreading-glasses";
      PUID = "1000";
      PGID = "100";
    };

    # Load HARDCOVER_AUTH and POSTGRES_PASSWORD from the same env file
    # used by the database container.
    environmentFiles = [ "/var/lib/rreading-glasses/env" ];

    ports = [
      "8788:8788"
    ];

    volumes = [
      "/storage/pool/Books:/storage/pool/Books"
    ];

    dependsOn = [ "rreading-glasses-db" ];
  };
}


