{ config, pkgs, ... }:
let
  tmuxScript = "${config.home.homeDirectory}/.config/tmux/tmux-autosession.sh";
in {
  home.file.".config/tmux/tmux-autosession.sh".source = ./tmux-autosession.sh;

  home.packages = with pkgs; [ tmux ];
  
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    extraConfig = ''
      set-option -g history-limit 10000
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ -n "$PS1" && -z "$TMUX" && -t 1 ]]; then
        bash "${tmuxScript}"
      fi
    '';
  };
}
