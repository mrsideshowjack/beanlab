{
  description = "Beanlab - NixOS Home Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, comin }: {
    nixosConfigurations.beanlab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Include Comin module
        comin.nixosModules.comin
        
        # Hardware configuration
        ./hardware-configuration.nix
        
        # System modules
        ./modules/system/variables.nix
        ./modules/system/users.nix  
        ./modules/system/storage.nix
        ./modules/system/dns.nix
        ./modules/services/comin.nix
        
        # Service modules
        ./modules/services/jellyfin.nix
        ./modules/services/immich.nix
        ./modules/services/paperless.nix
        ./modules/services/homepage
        
        # PIA VPN service module
        ./modules/services/pia-vpn.nix
        
        # Arr stack modules
        # ./modules/services/deluge.nix
        # ./modules/services/sonarr.nix
        # ./modules/services/radarr.nix
        # ./modules/services/prowlarr.nix
        
        # Main system configuration
        {
          # Basic system configuration
          boot.loader.grub.enable = true;
          boot.loader.grub.device = "/dev/sda";
          boot.loader.grub.useOSProber = true;

          networking.hostName = "beanlab";
          networking.networkmanager.enable = true;

          # Internationalization
          time.timeZone = "Asia/Tokyo";
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

          # X11 keymap
          services.xserver.xkb = {
            layout = "us";
            variant = "";
          };

          # Package management
          nixpkgs.config.allowUnfree = true;
          
          # Essential system packages
          environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
            vim       # Basic text editor
            wget      # Download tool
            curl      # HTTP client
            git       # Version control
            htop      # System monitor
            tree      # Directory tree viewer
            nano      # Simple text editor
            openssh   # SSH client/server
          ];

          # Enable SSH
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = true;
            };
          };

          # Firewall configuration
          networking.firewall.enable = false;

          # NixOS version
          system.stateVersion = "25.05";
        }
      ];
    };
  };
} 