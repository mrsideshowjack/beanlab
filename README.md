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

### Update Configuration
```bash
nixup  # Pull latest config from git and rebuild system
```

### Access Services
- **Jellyfin**: `http://BEANLAB_IP:8096`
- **SSH**: `ssh bean@BEANLAB_IP`


