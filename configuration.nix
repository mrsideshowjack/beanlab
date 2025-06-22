# Basic NixOS Configuration for Home Lab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "beanlab"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.bean = {
    isNormalUser = true;
    description = "Bean";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;  # Set zsh as default shell for user
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add zsh to available shells (required for user shell setting)
  environment.shells = with pkgs; [ zsh bash ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim       # Basic text editor
    wget      # Download tool
    curl      # HTTP client
    git       # Version control
    htop      # System monitor
    tree      # Directory tree viewer
    nano      # Simple text editor
    openssh   # SSH client/server
    
    # Storage management tools
    parted    # Partition management
    ntfs3g    # NTFS support for Windows drives
    rsync     # File synchronization
    rclone    # Advanced file sync/backup
    mergerfs  # Union filesystem for combining multiple drives
  ];

  # Configure zsh as the default shell with enhanced features
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      rebuild = "sudo nixos-rebuild switch";
      reboot-sys = "sudo reboot";
      nixup = "cd ~/beanlab && git pull && sudo cp configuration.nix /etc/nixos/ && sudo nixos-rebuild switch";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Also set system-wide aliases as fallback
  environment.shellAliases = {
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
        enable = true;
        settings = {
                PasswordAuthentication = true;
        };
  };

  # Enable Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "bean";  # Run as your user to avoid permission issues
  };

  # Enable Immich photo management
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";  # Listen on all interfaces instead of just localhost
    mediaLocation = "/storage/pool/pictures";
  };

  # Enable Homepage dashboard
  services.homepage-dashboard = {
    enable = true;
    listenPort = 80;
    openFirewall = true;
    
    allowedHosts = "localhost,127.0.0.1,192.168.1.100";
    
    settings = {
      title = "Beanlab";
      headerStyle = "clean";
      statusStyle = "dot";
      hideVersion = true;
      
      layout = [
        {
          "Media Services" = {
            style = "row";
            columns = 2;
          };
        }
        {
          "System Monitoring" = {
            style = "row";
            columns = 2;
          };
        }
      ];
    };

    services = [
      {
        "Media Services" = [
          {
            "Jellyfin" = {
              icon = "jellyfin";
              href = "http://192.168.1.100:8096";
              description = "Media Server - Movies, TV Shows, Music";
              siteMonitor = "http://192.168.1.100:8096";
            };
          }
          {
            "Immich" = {
              icon = "immich";
              href = "http://192.168.1.100:2283";
              description = "Photo Management & Backup";
              siteMonitor = "http://192.168.1.100:2283";
            };
          }
        ];
      }
      {
        "System Monitoring" = [
          {
            "System Storage" = {
              icon = "mdi-harddisk";
              href = "#";
              description = "Storage Pool: /storage/pool";
              widget = {
                type = "disk";
                path = "/storage/pool";
              };
            };
          }
          {
            "System Resources" = {
              icon = "mdi-memory";
              href = "#";
              description = "CPU, Memory, Network";
              widget = {
                type = "resources";
                cpu = true;
                memory = true;
                disk = "/storage/pool";
                cputemp = true;
                tempmin = 0;
                tempmax = 100;
                uptime = true;
              };
            };
          }
        ];
      }
    ];

    bookmarks = [
      {
        "Quick Links" = [
          {
            name = "Router";
            href = "http://192.168.1.1";
          }
          {
            name = "Beanlab SSH";
            href = "ssh://bean@192.168.1.100";
          }
        ];
      }
    ];
  };

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
      "cache.files=off" 
      "category.create=mfs" 
      "func.getattr=newest" 
      "dropcacheonclose=false" 
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

  # Open ports in the firewall.
  # For now firewall is disabled, but when enabled, add:
  # networking.firewall.allowedTCPPorts = [ 22 8096 2283 80 ];  # SSH, Jellyfin, Immich
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

} 