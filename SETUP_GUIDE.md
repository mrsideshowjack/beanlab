# NixOS Home Lab Setup Guide

This guide will help you set up a basic headless NixOS system for your home lab.

## Prerequisites

- NixOS installation ISO booted on your target machine
- Network cable connected to your router/switch
- Another computer to SSH from

## Two Installation Scenarios

### Scenario A: Fresh Installation (Manual Setup)
### Scenario B: Already Installed NixOS (Skip to Section 6)

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

**SSH Host Key Warning (REMOTE HOST IDENTIFICATION HAS CHANGED)?**
This happens when you reinstall/reconfigure the system. Fix it by removing the old host key:

Windows (WSL/PowerShell):
```bash
# Remove the specific line (replace line number from error message)
ssh-keygen -R 192.168.1.69

# Or edit the file manually
notepad C:\Users\YOUR_USERNAME\.ssh\known_hosts
# Delete the line mentioned in the error message
```

Linux/Mac:
```bash
# Remove the old host key
ssh-keygen -R 192.168.1.69

# Or remove specific line
sed -i '3d' ~/.ssh/known_hosts  # Replace 3 with the line number from error
```

**Need to modify configuration?**
```bash
# Edit configuration
sudo nano /etc/nixos/configuration.nix

# Rebuild and switch
sudo nixos-rebuild switch
```

## 6. Already Have NixOS Installed? (Alternative Path)

If you've already installed NixOS using the graphical installer and have a working system with internet access, follow these steps:

### Option 1: Install Git Temporarily and Clone Repository

1. **Install git temporarily:**
   ```bash
   # Add git to your current environment temporarily
   nix-shell -p git
   
   # Now clone the repository
   git clone https://github.com/YOUR_USERNAME/beanlab.git
   cd beanlab
   ```

2. **Apply the configuration:**
   ```bash
   # Copy our configuration to the system
   sudo cp configuration.nix /etc/nixos/
   
   # Rebuild the system with the new configuration
   sudo nixos-rebuild switch
   ```

3. **Create the bean user and set password:**
   ```bash
   # The bean user should now exist, set a password
   sudo passwd bean
   ```

### Option 2: Download Configuration Directly

If you prefer not to use git initially:

1. **Download the configuration file:**
   ```bash
   # Download the configuration directly
   curl -o configuration.nix https://raw.githubusercontent.com/YOUR_USERNAME/beanlab/main/configuration.nix
   
   # Copy to system location
   sudo cp configuration.nix /etc/nixos/
   ```

2. **Apply configuration:**
   ```bash
   sudo nixos-rebuild switch
   sudo passwd bean
   ```

### Option 3: Manual Creation

Copy the configuration manually:
```bash
sudo nano /etc/nixos/configuration.nix
# Copy and paste the entire configuration from the file
# Save and exit

sudo nixos-rebuild switch
sudo passwd bean
```

## Next Steps

After basic setup:
1. Set up SSH keys for better security
2. Configure any additional services you need
3. Consider setting up a firewall whitelist for your home network
4. Explore NixOS packages and services for your home lab needs 