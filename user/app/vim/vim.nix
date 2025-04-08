{ config, pkgs, ... }:

{ 
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      set relativenumber
    '';
  };
}
