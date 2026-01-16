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
    stateVersion = "25.11";
    username = "asd";
  };

  services = {
    ssh-agent.enable = true;
  };

  home.packages = with pkgs; [
    procps
    ripgrep
  ];

  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/nvim/colors/molokai.vim".source = /etc/nixos/x1a1/asd/.config/nvim/colors/molokai.vim;
    };
}
