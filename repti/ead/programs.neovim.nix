{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-dap
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-jinja
        tree-sitter-json
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-ruby
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-yaml
      ]))
      rustaceanvim
    ];

    extraLuaConfig = builtins.readFile ./programs.neovim.extraLuaConfig.lua;
  };
}
