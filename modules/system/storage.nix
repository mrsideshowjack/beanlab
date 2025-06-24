# Storage management configuration
{ config, pkgs, ... }:

{
  # Storage mounts
  fileSystems."/storage/disk1" = {
    device = "/dev/disk/by-label/storage-1tb";
    fsType = "ext4";
    options = [ "defaults" "user" ];
  };

  fileSystems."/storage/disk2" = {
    device = "/dev/disk/by-label/storage-2tb";
    fsType = "ext4";
    options = [ "defaults" "user" ];
  };

  # MergerFS configuration - combine multiple drives into unified storage
  fileSystems."/storage/pool" = {
    device = "/storage/disk1:/storage/disk2";
    fsType = "fuse.mergerfs";
    options = [ 
      "cache.files=partial"     # Enable caching to fix mmap issues with torrent clients
      "category.create=mfs" 
      "func.getattr=newest" 
      "dropcacheonclose=true"   # Enable cache cleanup for non-direct_io mode
      "allow_other" 
      "use_ino" 
    ];
  };

  # Create storage directories
  systemd.tmpfiles.rules = [
    "d /storage 0755 bean users -"
    "d /storage/disk1 0755 bean users -"
    "d /storage/disk2 0755 bean users -"
    "d /storage/pool 0755 bean users -"
  ];

  # Storage management tools
  environment.systemPackages = with pkgs; [
    parted    # Partition management
    ntfs3g    # NTFS support for Windows drives
    rsync     # File synchronization
    rclone    # Advanced file sync/backup
    mergerfs  # Union filesystem for combining multiple drives
  ];
} 