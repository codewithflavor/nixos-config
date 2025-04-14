{ config, pkgs, ... }:

{
  imports = [
    ./user/shell/tmux.nix
    ./user/shell/bash.nix
    ./user/app/git/git.nix
    ./user/app/vim/vim.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yanex";
  home.homeDirectory = "/home/yanex";
   
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [ tldr ];

  home.file = { };
 
  programs.home-manager.enable = true;
}
