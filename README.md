# beanlab

A headless NixOS home lab server configuration for media storage and services.

## Overview

This repository contains the complete NixOS configuration for "beanlab" - a headless media server running on custom hardware with unified storage management.

## What's Included

### 🖥️ **System Configuration**
- **Hostname**: `beanlab` 
- **User**: `bean` (admin user with sudo access)
- **Shell**: Zsh 

### 🗄️ **Storage Setup**
- **SSD**: NixOS system drive
- **1TB HDD**: Primary storage (`/storage/disk1`)
- **2TB HDD**: Expansion storage (`/storage/disk2`) 
- **MergerFS**: Unified storage pool (`/storage/pool`) combining both HDDs

### 📺 **Services**
- **Jellyfin**: Media server (port 8096)
- **Bookshelf**: Book management (Readarr fork) via Docker/Podman (port 8787)
- **rreading-glasses**: Hardcover-backed metadata service for Bookshelf (port 8788)
- **SSH**: Remote access (port 22)
- **NetworkManager**: Automatic network configuration

### 📁 **Media Organization**
```
/storage/pool/
├── Video/     (Movies, TV shows, anime)
├── Music/     (Audio content)
└── Files/     (Documents, software)
```

## Usage

### GitOps Deployment
With Comin GitOps, updates are automatic just push changes to deploy:

```bash
# Make changes to configuration
git add .
git commit -m "Update configuration"
git push  # Changes deploy automatically!
```

### Manual Rebuild (Emergency Use)
```bash
rebuild  # Rebuild system manually using flake
```

### Access Services
- **Jellyfin**: `http://BEANLAB_IP:8096`
- **Bookshelf (Readarr fork)**: `http://BEANLAB_IP:8787`
- **rreading-glasses (Hardcover metadata)**: `http://BEANLAB_IP:8788`
- **SSH**: `ssh bean@BEANLAB_IP`

### rreading-glasses Hardcover setup (one time)
- Create a Hardcover account and get an API token (`Settings → Hardcover API`), including the `Bearer` prefix as documented in the rreading-glasses README (`https://github.com/blampe/rreading-glasses?tab=readme-ov-file#usage`).
- On `beanlab`, create `/var/lib/rreading-glasses/env` owned by root and add:
  - `HARDCOVER_AUTH=Bearer <your_token>`
  - `POSTGRES_PASSWORD=rreading-glasses-db-p4ssw0rd` (must match the password in `modules/services/rreading-glasses.nix`).
- Run `rebuild` (or wait for Comin) so the containers pick up the env file.

### Bookshelf first-run notes
- Access `http://BEANLAB_IP:8787` and complete the initial setup (admin user, basic settings).
- Configure libraries to point at your storage pool (for example under `/storage/pool/`).
- Configure your download client (Deluge) and indexers via Prowlarr as usual; Bookshelf should behave like Readarr from their perspective.


