# Deluge BitTorrent client configuration
{ config, pkgs, ... }:

{
  # Enable Deluge BitTorrent client
  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;
    user = "bean";
    group = "users";
    dataDir = "/storage/pool/torrents/.deluge";
    
    # Deluge daemon configuration
    config = {
      download_location = "/storage/pool/torrents/downloads";
      torrentfiles_location = "/storage/pool/torrents/torrent-files";
      move_completed_path = "/storage/pool/torrents/completed";
      copy_torrent_file = true;
      del_copy_torrent_file = false;
      allow_remote = true;
      daemon_port = 58846;
      listen_ports = [ 6881 6889 ];
      random_port = false;
      max_upload_speed = 1000.0;
      max_download_speed = -1.0;
      share_ratio_limit = 2.0;
      seed_time_ratio_limit = 7.0;
      seed_time_limit = 180;
      remove_seed_at_ratio = false;
      max_active_downloading = 8;
      max_active_seeding = 5;
      max_active_limit = 10;
    };
    
    # Auth file for remote access
    authFile = pkgs.writeText "deluge-auth" ''
      bean:beanlab:10
    '';
  };

  # Enable Deluge web interface
  services.deluge.web = {
    enable = true;
    port = config.beanlab.ports.deluge;
    openFirewall = true;
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /storage/pool/torrents 0755 bean users -"
    "d /storage/pool/torrents/downloads 0755 bean users -"
    "d /storage/pool/torrents/completed 0755 bean users -"
    "d /storage/pool/torrents/torrent-files 0755 bean users -"
    "d /storage/pool/torrents/.deluge 0755 bean users -"
  ];
} 