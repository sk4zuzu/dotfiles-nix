{ config, pkgs, ... }: {
  imports = [
    ./programs.bash.nix
    ./programs.git.nix
    ./programs.mc.nix
    ./programs.neovim.nix
    ./programs.ssh.nix
  ];

  programs = {
    home-manager.enable = true;
  };

  home = {
    homeDirectory = "/home/asd";
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "26.05";
    username = "asd";
  };

  home.packages =
    let
      python3-with-pkgs = pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
        ansible-core
        pip python
        virtualenv
        yamllint
      ]);
      ruby-with-pkgs = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
        rspec rubocop
      ]);
    in with pkgs; [
      ansible-lint
      bat binutils
      cdrkit cloud-utils curl
      dpkg
      fd
      gnumake graphviz-nox
      hatch
      #igrep
      jq
      libarchive libosinfo libxml2 libxslt
      pandoc patch procps procs
      ripgrep rpm
      uv
      wget which
    ] ++ [
      gcc go gopls
      nodejs
      tree-sitter
    ] ++ [
      python3-with-pkgs
      ruby-with-pkgs
    ];

  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/nvim/colors/molokai.vim".source = /etc/nixos/repti/asd/.config/nvim/colors/molokai.vim;
    };
}
