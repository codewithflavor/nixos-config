{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-authenticator
  ];

  services.openssh = {
    enable = true;
    settings ={
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = true;
    };
  };
  
  security.pam = {
    services.sshd.googleAuthenticator.enable = true;
    services.login.googleAuthenticator.enable = true;
  };
}
