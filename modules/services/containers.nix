{ ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;

    # Enable DNS-based container name resolution on the default network
    # so containers like rreading-glasses can reach rreading-glasses-db
    # via POSTGRES_HOST = "rreading-glasses-db".
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };
}


