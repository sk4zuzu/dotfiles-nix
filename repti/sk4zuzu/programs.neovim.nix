{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-haskell
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-make
        tree-sitter-nix
        tree-sitter-vim
      ]))
    ];

    extraLuaConfig = builtins.readFile ./programs.neovim.extraLuaConfig.lua;
  };
}
