vim.diagnostic.config({
  underline = false,
  virtual_lines = true,
})

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { features = 'all' },
        semanticHighlighting = {
          strings = { enable = false },
        },
      },
    },
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  callback = function()
    vim.treesitter.query.set("rust", "injections", [[
      ; extends
      (macro_invocation
        macro: ((identifier) @_id (#eq? @_id "bash"))
        (token_tree
          (raw_string_literal
            ((string_content) @injection.content
              (#set! injection.language "bash")
              (#set! injection.include-children)))))
      (macro_invocation
        macro: ((identifier) @_id (#eq? @_id "jinja"))
        (token_tree
          (raw_string_literal
            ((string_content) @injection.content
              (#set! injection.language "jinja")
              (#set! injection.include-children)))))
    ]])
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'make' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'bash', 'ruby' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'markdown', 'toml', 'yaml' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 2
    vim.o.sw = 2
    vim.o.et = true
  end,
})

vim.cmd [[
  syntax on
  colorscheme molokai

  set backspace=2
  set modeline
  set number

  set nobackup
  set nowritebackup
  set noundofile

  filetype plugin indent on

  set noautoindent
  set nosmartindent
  set nocindent
  set nowrap

  highlight RedundantSpaces ctermbg=blue guibg=blue
  match RedundantSpaces /\s\+$\| \+\ze\t/
]]
