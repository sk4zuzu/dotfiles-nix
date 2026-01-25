{ ... }: {
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      SSH_AGENT_PID="$(pgrep -u "$USER" ssh-agent)"
      if [[ -n "$SSH_AGENT_PID" ]]; then
          export SSH_AGENT_PID SSH_AUTH_SOCK="$HOME/.ssh/.agent"
      else
          rm -f "$HOME/.ssh/.agent"
          eval "$(ssh-agent -a "$HOME/.ssh/.agent")"
          fd -tf -E 'id_*.pub' 'id_*' "$HOME/.ssh/" -x ssh-add
      fi
    '';

    initExtra =
      let
        magenta = "\\033[38;2;255;0;255m";
        clear = "\\033[0m";
      in ''
        export TERM='xterm-256color'
        export PS1='${magenta}\w\$ ${clear}'
        export EDITOR='nvim'
        cd ~/_git/
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
