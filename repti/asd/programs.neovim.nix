{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-awk
        tree-sitter-bash
        tree-sitter-diff
        tree-sitter-go
        tree-sitter-hcl
        tree-sitter-ini
        tree-sitter-jinja
        tree-sitter-json
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-ruby
        tree-sitter-terraform
        tree-sitter-udev
        tree-sitter-yaml
        tree-sitter-xml
      ]))
    ];

    initLua = builtins.readFile ./programs.neovim.initLua.lua;
  };
}
