{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-go
        tree-sitter-hcl
        tree-sitter-jinja
        tree-sitter-json
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-ruby
        tree-sitter-terraform
        tree-sitter-yaml
      ]))
    ];

    extraLuaConfig = builtins.readFile ./programs.neovim.extraLuaConfig.lua;
  };
}
