{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ tmux ];
  
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    extraConfig = ''
      set-option -g history-limit 10000
    '';
  };
}
