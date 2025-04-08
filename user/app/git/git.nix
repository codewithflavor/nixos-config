{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jan Kliszcz";
    userEmail = "kliszczjan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
