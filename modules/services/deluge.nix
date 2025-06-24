# Deluge BitTorrent client configuration
{ config, pkgs, lib, ... }:

{
  # Create multimedia group for media services
  users.groups.multimedia = { };
  
  # Add bean user to multimedia group
  users.users.bean.extraGroups = [ "multimedia" ];

  # Enable Deluge BitTorrent client
  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;
    user = "bean";
    group = "multimedia";
    dataDir = "/storage/pool/media/torrent";
    
    # Deluge daemon configuration
    config = {
      download_location = "/storage/pool/media/torrent/downloads";
      torrentfiles_location = "/storage/pool/media/torrent/torrent-files";
      move_completed_path = "/storage/pool/media/torrent/completed";
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
      enabled_plugins = [ "Label" ];
      # Bind to VPN interface for all traffic
      outgoing_interface = "tun0";
    };
    
    # Auth file for remote access
    authFile = pkgs.writeText "deluge-auth" ''
      localclient::10
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
    "d /storage/pool/media 0770 - multimedia - -"
    "d /storage/pool/media/torrent 0770 bean multimedia - -"
    "d /storage/pool/media/torrent/downloads 0770 bean multimedia - -"
    "d /storage/pool/media/torrent/completed 0770 bean multimedia - -"
    "d /storage/pool/media/torrent/torrent-files 0770 bean multimedia - -"
  ];
} 