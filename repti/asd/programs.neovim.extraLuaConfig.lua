vim.diagnostic.config({
  underline = false,
  virtual_lines = true,
})

vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'make' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'bash', 'python', 'ruby' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'hcl', 'json', 'markdown', 'terraform' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 2
    vim.o.sw = 2
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'yaml' },
  callback = function()
    vim.treesitter.query.set("yaml", "injections", [[
      ; extends
      (
        [
          (flow_node (single_quote_scalar) @injection.content)
          (flow_node (double_quote_scalar) @injection.content)
          (block_node (block_scalar) @injection.content)
        ]
        (#set! injection.language "jinja")
        (#set! injection.include-children)
      )
      (block_mapping_pair
        key: (flow_node (plain_scalar (string_scalar) @_id))
        value:
          [
            (flow_node (single_quote_scalar) @injection.content)
            (flow_node (double_quote_scalar) @injection.content)
          ]
        (#any-of? @_id "cmd")
        (#offset! @injection.content 0 1 0 -1)
        (#set! injection.language "bash")
        (#set! injection.include-children)
      )
      (block_mapping_pair
        key: (flow_node (plain_scalar (string_scalar) @_id))
        value:
          [
            (flow_node (plain_scalar (string_scalar) @injection.content))
            (block_node (block_scalar) @injection.content)
          ]
        (#any-of? @_id "cmd")
        (#set! injection.language "bash")
        (#set! injection.include-children)
      )
      (block_mapping_pair
        key: (flow_node (plain_scalar (string_scalar) @_id))
        value:
          [
            (flow_node (plain_scalar (string_scalar) @injection.content))
            (block_node (block_sequence (block_sequence_item (flow_node (plain_scalar (string_scalar) @injection.content)))))
          ]
        (#any-of? @_id "changed_when" "failed_when" "that" "when")
        (#set! injection.language "python")
        (#set! injection.include-children)
      )
    ]])
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
