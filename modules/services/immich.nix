# Immich photo management configuration via docker-compose on Podman
{ config, pkgs, nixpkgs-unstable, ... }:

let
  baseDir = "/var/lib/immich";
  composeDir = "${baseDir}/app";
  uploadDir = "/storage/pool/pictures";
  dbDataDir = "${baseDir}/postgres";
  immichPort = config.beanlab.ports.immich;
  tz =
    if config ? time && config.time ? timeZone then
      config.time.timeZone
    else
      "UTC";

  dockerComposeFile = pkgs.writeText "immich-docker-compose.yml" ''
    name: immich

    services:
      immich-server:
        container_name: immich_server
        image: ghcr.io/immich-app/immich-server:\${IMMICH_VERSION:-v2}
        volumes:
          # Do not edit the next line. If you want to change the media storage location on your system,
          # edit the value of UPLOAD_LOCATION in the .env file
          - \${UPLOAD_LOCATION}:/data
          - /etc/localtime:/etc/localtime:ro
        env_file:
          - .env
        ports:
          # Map the configured Immich port on the host to the container port
          - '\${IMMICH_PORT:-2283}:2283'
        depends_on:
          - redis
          - database
        restart: always
        healthcheck:
          disable: false

      immich-machine-learning:
        container_name: immich_machine_learning
        # For hardware acceleration, add one of -[armnn, cuda, rocm, openvino, rknn] to the image tag.
        # Example tag: \${IMMICH_VERSION:-v2}-cuda
        image: ghcr.io/immich-app/immich-machine-learning:\${IMMICH_VERSION:-v2}
        volumes:
          - model-cache:/cache
        env_file:
          - .env
        restart: always
        healthcheck:
          disable: false

      redis:
        container_name: immich_redis
        image: docker.io/valkey/valkey:9@sha256:2bce660b767cb62c8c0ea020e94a230093be63dbd6af4f21b044960517a5842d
        healthcheck:
          test: redis-cli ping || exit 1
        restart: always

      database:
        container_name: immich_postgres
        image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23
        environment:
          POSTGRES_PASSWORD: \${DB_PASSWORD}
          POSTGRES_USER: \${DB_USERNAME}
          POSTGRES_DB: \${DB_DATABASE_NAME}
          POSTGRES_INITDB_ARGS: '--data-checksums'
        volumes:
          # Do not edit the next line. If you want to change the database storage location on your system,
          # edit the value of DB_DATA_LOCATION in the .env file
          - \${DB_DATA_LOCATION}:/var/lib/postgresql/data
        shm_size: 128mb
        restart: always
        healthcheck:
          disable: false

    volumes:
      model-cache:
  '';

  envFile = pkgs.writeText "immich.env" ''
    # Core Immich configuration
    IMMICH_VERSION=v2
    IMMICH_PORT=${toString immichPort}
    TZ=${tz}

    # Media and database locations
    UPLOAD_LOCATION=${uploadDir}
    DB_DATA_LOCATION=${dbDataDir}

    # Database credentials
    DB_USERNAME=immich
    DB_PASSWORD=immich-db-password-change-me
    DB_DATABASE_NAME=immich
  '';
in
{
  # Ensure Podman is available with docker-compat so `docker compose` uses Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Filesystem layout for Immich docker deployment
  systemd.tmpfiles.rules = [
    "d ${baseDir} 0755 root root - -"
    "d ${composeDir} 0755 root root - -"
    "d ${dbDataDir} 0700 root root - -"
  ];

  # Open the Immich HTTP port on the firewall (if accessed directly)
  networking.firewall.allowedTCPPorts = [ immichPort ];

  # Systemd unit managing the docker-compose stack via Podman
  systemd.services.immich-docker = {
    description = "Immich photo management via docker-compose (Podman backend)";
    after = [ "network-online.target" "podman.service" ];
    wants = [ "network-online.target" ];
    requires = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];

    # Copy/sync the Nix-managed compose and env files into the runtime directory
    preStart = ''
      install -d -m 0755 -o root -g root ${composeDir}
      cp ${dockerComposeFile} ${composeDir}/docker-compose.yml
      cp ${envFile} ${composeDir}/.env
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = composeDir;
      ExecStart = "/run/current-system/sw/bin/docker compose up --detach";
      ExecStop = "/run/current-system/sw/bin/docker compose down";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}