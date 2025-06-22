# Comin GitOps deployment service
{ config, pkgs, ... }:

{
  # Enable Comin for GitOps deployment
  services.comin = {
    enable = true;
    
    # Configure git remotes
    remotes = [
      {
        name = "origin";
        url = config.beanlab.system.repoURL;
        branches = {
          main.name = "main";
          testing.name = "testing-beanlab";
        };
      }
      # Optional: Local repo for fast iteration
      {
        name = "local";
        url = "/home/bean/beanlab";
        poller.period = 5;  # Poll every 5 seconds
        branches.main.name = "main";
      }
    ];
    
    # Optional: GPG signature verification for security
    # gpgPublicKeyPaths = [ "/etc/comin/gpg-keys/your-key.asc" ];
  };
} 