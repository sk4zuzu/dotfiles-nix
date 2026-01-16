{ config, pkgs, ... }: {
  imports = [
    ./programs.alacritty.nix
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
    homeDirectory = "/home/sk4zuzu";
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "26.05";
    username = "sk4zuzu";
  };

  home.packages = with pkgs; [
    bat
    curl
    fd ffmpeg
    gnumake
    htop
    igrep
    jq
    patch
    ripgrep
    wget which
    yt-dlp
  ] ++ [
    gcc
    nodejs
    tree-sitter
  ] ++ [
    chromium
    dmenu dunst
    hsetroot
    libnotify
    pavucontrol procps
    redshift
    slock
  ] ++ [
    gimp
    maim mpv mupdf
    remmina
    transmission_4-gtk
  ] ++ [
    dosbox-staging
    mame
    (wine.override { wineRelease = "staging"; }) winetricks
  ];

  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/mpv/scripts/eww.lua".source = ln "/etc/nixos/repti/sk4zuzu/.config/mpv/scripts/eww.lua";
      ".config/nvim/colors/molokai.vim".source = /etc/nixos/repti/sk4zuzu/.config/nvim/colors/molokai.vim;
      ".config/redshift.conf".source = ln "/etc/nixos/repti/sk4zuzu/.config/redshift.conf";
      ".local/bin/acpi.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/acpi.sh";
      ".local/bin/asd".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/asd";
      ".local/bin/ead".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/ead";
      ".local/bin/xrandr.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/xrandr.sh";
      ".local/share/fonts".source = /etc/nixos/repti/sk4zuzu/.local/share/fonts;
      ".xmonad/xmonad.hs".source = ln "/etc/nixos/repti/sk4zuzu/.xmonad/xmonad.hs";
    };
}
