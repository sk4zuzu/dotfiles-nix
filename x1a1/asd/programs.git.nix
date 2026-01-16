{ ... }: {
  programs.git = {
    enable = true;

    settings.alias = {
      a = "add";
      c = ''! f(){ [ -n "$*" ] && git commit -m "$*" || git commit; }; f'';
      ca = "commit --amend";
      co = "checkout";
      d = "diff";
      f = "fetch";
      l = "log";
      s = "show";
      ss = "status";
      t = "tag";
    };

    settings.safe.directory = ["/etc/nixos"];

    settings.user = {
      email = "sk4zuzu@gmail.com";
      name = "Michal Opala";
    };
  };
}
