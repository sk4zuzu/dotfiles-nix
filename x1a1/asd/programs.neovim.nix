{ ... }: {
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./programs.neovim.extraLuaConfig.lua;
  };
}
