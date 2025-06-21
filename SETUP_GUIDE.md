# NixOS Home Lab Setup Guide

This guide will help you set up a basic headless NixOS system for your home lab.

## Prerequisites

- NixOS installation ISO booted on your target machine
- Network cable connected to your router/switch
- Another computer to SSH from

## Step-by-Step Installation

### 1. Initial NixOS Installation

1. Boot from the NixOS installation ISO
2. Set up networking (should work automatically with DHCP):
   ```bash
   # Check if network is working
   ping google.com
   ```

3. Partition your disk (basic single-disk setup):
   ```bash
   # List available disks
   lsblk
   
   # Partition the disk (replace /dev/sda with your disk)
   sudo fdisk /dev/sda
   # Create a new GPT partition table: g
   # Create EFI partition: n, 1, enter, +500M, t, 1
   # Create root partition: n, 2, enter, enter, w
   
   # Format partitions
   sudo mkfs.fat -F32 /dev/sda1
   sudo mkfs.ext4 /dev/sda2
   
   # Mount partitions
   sudo mount /dev/sda2 /mnt
   sudo mkdir /mnt/boot
   sudo mount /dev/sda1 /mnt/boot
   ```

4. Generate initial configuration:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

### 2. Apply Custom Configuration

1. Replace the generated configuration with our custom one:
   ```bash
   # Clone this repository to get the configuration
   git clone https://github.com/YOUR_USERNAME/beanlab.git /tmp/beanlab
   
   # Copy our configuration
   sudo cp /tmp/beanlab/configuration.nix /mnt/etc/nixos/
   ```

2. Edit the configuration if needed:
   ```bash
   sudo nano /mnt/etc/nixos/configuration.nix
   ```
   
       **Important customizations:**
    - Timezone is set to Asia/Tokyo
    - Hostname is set to "beanlab" 
    - Update `networking.interfaces.eth0.useDHCP` if your network interface isn't eth0

3. Install NixOS:
   ```bash
   sudo nixos-install
   ```

4. Set root password when prompted
5. Reboot:
   ```bash
   sudo reboot
   ```

### 3. Post-Installation Setup

1. After reboot, log in as root locally
2. Set password for the bean user:
   ```bash
   passwd bean
   ```

3. Find your IP address:
   ```bash
   ip addr show
   # Look for inet x.x.x.x under your network interface
   ```

### 4. SSH Access

From another computer on your network:
```bash
# SSH as the bean user
ssh bean@YOUR_NIXOS_IP

# Or as root (if you enabled root login)
ssh root@YOUR_NIXOS_IP
```

### 5. Clone Your Repository

Once connected via SSH:
```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/beanlab.git
cd beanlab

# Make any changes you need
# The system already has git, vim, nano, and other essential tools installed
```

## Configuration Highlights

This configuration includes:

- **Networking**: NetworkManager with DHCP enabled
- **SSH**: OpenSSH server with password authentication
- **Firewall**: Enabled with SSH port (22) open
- **User**: `bean` user with sudo privileges
- **Packages**: Essential tools (git, vim, nano, htop, etc.)
- **Security**: Basic setup (consider hardening for production)

## Security Notes

⚠️ **This is a basic configuration suitable for a home lab. For production use, consider:**

- Disabling root SSH login
- Using SSH keys instead of passwords
- Enabling fail2ban for SSH protection
- Requiring password for sudo
- Setting up proper firewall rules
- Regular security updates

## Troubleshooting

**Network not working?**
- Check cable connections
- Verify interface name with `ip link show`
- Update `networking.interfaces.eth0.useDHCP` to match your interface

**Can't SSH?**
- Check if SSH service is running: `systemctl status sshd`
- Verify firewall: `sudo iptables -L`
- Check if port 22 is listening: `sudo netstat -tlnp | grep :22`

**Need to modify configuration?**
```bash
# Edit configuration
sudo nano /etc/nixos/configuration.nix

# Rebuild and switch
sudo nixos-rebuild switch
```

## Next Steps

After basic setup:
1. Set up SSH keys for better security
2. Configure any additional services you need
3. Consider setting up a firewall whitelist for your home network
4. Explore NixOS packages and services for your home lab needs 