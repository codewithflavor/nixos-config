{ config, pkgs, ... }:

{
  imports = [
    ./user/shell/tmux.nix
    ./user/shell/bash.nix
    ./user/app/git/git.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yanex";
  home.homeDirectory = "/home/yanex";
   
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [ ];

  home.file = { };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  programs.home-manager.enable = true;
}
