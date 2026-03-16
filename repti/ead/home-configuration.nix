{ config, pkgs, rustaceanvim, ... }: {
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
    homeDirectory = "/home/ead";
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "26.05";
    username = "ead";
  };

  services = {
    podman = {
      enable = true;
      settings.containers.engine = {
        cgroup_manager = "cgroupfs";
      };
      settings.storage.storage = {
        driver = "overlay";
        graphroot = "/stor/ead/.local/share/containers/storage";
      };
    };
  };

  home.packages =
    let
      ruby-with-pkgs = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
        rspec
      ]);
      rustaceanvim-pkgs = rustaceanvim.packages.${pkgs.stdenv.hostPlatform.system};
    in with pkgs; [
      bat
      curl
      fd
      gnumake
      igrep
      jq
      patch procps procs
      ripgrep ruby-with-pkgs
      which
    ] ++ [
      cargo
      gcc
      lldb
      nodejs
      rust-analyzer rustc
      tree-sitter
    ] ++ [
      rustaceanvim-pkgs.codelldb
      rustaceanvim-pkgs.rustaceanvim
    ];

  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/nvim/colors/molokai.vim".source = /etc/nixos/repti/ead/.config/nvim/colors/molokai.vim;
    };
}
