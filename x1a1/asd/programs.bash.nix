{ ... }: {
  programs.bash = {
    enable = true;

    initExtra = ''
      export TERM='xterm-256color'
      export PS1='\w\$ '
      export EDITOR='nvim'
    '';

    shellAliases = {
      b = "bash";
      g = "git";
      hrg = "history | rg";
      m = "make";
      prg = "ps --no-header -eww -o pid,user,cmd | rg";
      root = "doas -s";
      v = "nvim";
      vim = "nvim";
    };
  };
}
