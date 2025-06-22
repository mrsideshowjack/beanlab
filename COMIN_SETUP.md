# Comin GitOps Setup for Beanlab

This guide shows how to set up [Comin](https://github.com/nlewo/comin) for automated GitOps deployment.

## 🎯 **What Comin Provides**

- 🚀 **Git push to deploy** - No more manual file copying
- 🧪 **Testing branches** - Safe testing with `testing-beanlab` branch
- ⚡ **Fast iteration** - Local repo polling every 5 seconds  
- 🔒 **Security** - Optional GPG signature verification
- 📊 **Monitoring** - Built-in Prometheus metrics

## 🔄 **Workflow Comparison**

### **Before (Manual):**
```bash
cd ~/beanlab
git pull
sudo rsync -av ./ /etc/nixos/
sudo nixos-rebuild switch  # Manual, error-prone
```

### **After (GitOps):**
```bash
git add .
git commit -m "Add new service"
git push origin main
# ✨ Server automatically deploys in ~60 seconds!
```

## 🛠 **Setup Steps**

### **1. Enable Flakes (Required)**

Add to your current `configuration.nix`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Apply this first:
```bash
sudo nixos-rebuild switch
```

### **2. Initial Flake Deployment**

Copy the flake configuration and deploy manually (one time only):
```bash
# Copy flake to /etc/nixos/
sudo cp flake.nix /etc/nixos/
sudo cp flake.lock /etc/nixos/ # if it exists
sudo cp -r modules /etc/nixos/

# Deploy with flakes
sudo nixos-rebuild switch --flake /etc/nixos#beanlab
```

### **3. Update Git Repository**

Ensure your GitHub repo is public or configure SSH access:
```bash
# Push your flake configuration
git add flake.nix flake.lock modules/
git commit -m "Add Comin GitOps configuration"
git push origin main
```

### **4. Comin Takes Over**

After the initial deployment, Comin will:
- Poll your GitHub repo every 60 seconds
- Poll local repo every 5 seconds (for fast development)
- Automatically deploy changes

## 🧪 **Testing Workflow**

### **Test Configuration Changes:**

1. **Create testing branch:**
   ```bash
   git checkout -b testing-beanlab
   # Make your changes
   git add .
   git commit -m "Test: Add new widget"
   git push origin testing-beanlab
   ```

2. **Comin deploys with `nixos-rebuild test`:**
   - Configuration is applied but bootloader isn't updated
   - Safe testing without affecting boot

3. **If tests pass, merge to main:**
   ```bash
   git checkout main
   git merge testing-beanlab
   git push origin main
   # Now deployed permanently with `nixos-rebuild switch`
   ```

### **Fast Local Development:**

Comin polls your local repo every 5 seconds:
```bash
# Make changes locally
git add .
git commit -m "Quick fix"
# Deploys in ~5 seconds automatically!
```

## 🔧 **New Aliases**

Your shell now includes GitOps-friendly aliases:

```bash
deploy          # Add, commit, and push to main
deploy-test     # Create and push testing branch
manual-rebuild  # Emergency manual rebuild
```

## 📊 **Monitoring**

Comin provides Prometheus metrics at `http://bean.lab:9090/metrics` for monitoring deployment status.

## 🛡️ **Security Features**

### **GPG Signature Verification (Optional):**

1. **Generate GPG key:**
   ```bash
   gpg --gen-key
   ```

2. **Export public key:**
   ```bash
   gpg --armor --export your-email@example.com > /etc/comin/gpg-keys/your-key.asc
   ```

3. **Enable in configuration:**
   ```nix
   services.comin = {
     enable = true;
     gpgPublicKeyPaths = [ "/etc/comin/gpg-keys/your-key.asc" ];
     # ... rest of config
   };
   ```

4. **Sign commits:**
   ```bash
   git commit -S -m "Signed commit"
   ```

## 🚨 **Emergency Procedures**

### **If Comin Breaks:**

1. **Disable Comin:**
   ```bash
   sudo systemctl stop comin
   sudo systemctl disable comin
   ```

2. **Manual rebuild:**
   ```bash
   manual-rebuild  # Uses the alias
   ```

3. **Revert to manual deployment:**
   - Switch back to non-flake configuration
   - Use old `nixup` approach

### **Rollback to Previous Configuration:**

```bash
sudo nixos-rebuild switch --rollback
```

## 📈 **Benefits for Your Homelab**

1. **Professional workflow** - Industry-standard GitOps
2. **Safe testing** - Test branches prevent breaking production
3. **Fast iteration** - Local repo for quick development
4. **Version control** - Full git history of all changes
5. **Remote deployment** - Push from anywhere
6. **Monitoring** - Built-in metrics and logging

## 🔄 **Migration Plan**

1. **Phase 1:** Set up flakes with current config (manual deploy once)
2. **Phase 2:** Enable Comin and test with simple changes
3. **Phase 3:** Full GitOps workflow adoption
4. **Phase 4:** Add security features (GPG signing)

This transforms your homelab into a production-grade, GitOps-managed infrastructure! 