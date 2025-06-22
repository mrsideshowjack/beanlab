# User management configuration
{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.bean = {
    isNormalUser = true;
    description = "Bean";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;  # Set zsh as default shell for user
    packages = with pkgs; [];
  };

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
      rebuild = "sudo nixos-rebuild switch --flake .#beanlab";
      reboot-sys = "sudo reboot";
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

  # Add zsh to available shells (required for user shell setting)
  environment.shells = with pkgs; [ zsh bash ];
} 