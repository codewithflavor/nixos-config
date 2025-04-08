{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ git onefetch ];
  
  programs.git = {
    enable = true;
    userName = "Jan Kliszcz";
    userEmail = "kliszczjan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
