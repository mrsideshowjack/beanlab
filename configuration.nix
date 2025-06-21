# Basic NixOS Configuration for Home Lab
# Edit this file to configure your system. See the manual (nixos-help)

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network configuration
  networking.hostName = "beanlab"; # Define your hostname
  networking.networkmanager.enable = true;  # Enable NetworkManager for easy network management
  
  # Enable DHCP on the primary network interface (usually eth0 for wired connections)
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  
  # Open ports in the firewall for SSH
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;

  # Set your time zone
  time.timeZone = "Asia/Tokyo"; # Change to your timezone

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes"; # Allow root login via SSH (change to "no" for better security)
      PasswordAuthentication = true; # Allow password authentication
    };
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.bean = {
    isNormalUser = true;
    description = "Bean Admin User";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable 'sudo' for the user
    packages = with pkgs; [
      # Add user-specific packages here if needed
    ];
  };

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false; # Remove this line for better security

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim       # Basic text editor
    wget      # Download tool
    curl      # HTTP client
    git       # Version control
    htop      # System monitor
    tree      # Directory tree viewer
    nano      # Simple text editor
    openssh   # SSH client/server
  ];

  # Enable automatic upgrades (optional, comment out if you prefer manual control)
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this after installation!
  system.stateVersion = "23.11"; # Did you read the comment?
} 