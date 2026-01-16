{ ... }: {
  programs.bash = {
    enable = true;

    initExtra = ''
      export TERM='xterm-256color'
      export PS1='\u:\w\$ '
      export EDITOR='nvim'
      cd /etc/nixos/
    '';

    shellAliases = {
      b = "bash";
      g = "git";
      hrg = "history | rg";
      m = "make";
      prg = "ps --no-header -eww -o pid,user,cmd | rg";
      root = "doas -s";
      vim = "nvim";
    };
  };
}
