vim.diagnostic.config({
  underline = false,
  virtual_lines = true,
})

vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'make' },
  callback = function()
    vim.treesitter.query.set('make', 'injections', [[
      ; extends
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_(BASH|SH)$")
        (#set! injection.language "bash")
        (#set! injection.include-children)
      )
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_HCL$")
        (#set! injection.language "hcl")
        (#set! injection.include-children)
      )
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_JSON$")
        (#set! injection.language "json")
        (#set! injection.include-children)
      )
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_MAKE$")
        (#set! injection.language "make")
        (#set! injection.include-children)
      )
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_XML$")
        (#set! injection.language "xml")
        (#set! injection.include-children)
      )
      (define_directive
        name: (word) @_id
        value: (raw_text) @injection.content
        (#match? @_id "^\\w+_(YAML|YML)$")
        (#set! injection.language "yaml")
        (#set! injection.include-children)
      )
    ]])
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'bash', 'sh' },
  callback = function(args)
    vim.treesitter.start(args.buf, 'bash')
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'ruby' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'hcl', 'json', 'markdown', 'nix', 'terraform' },
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
    vim.treesitter.query.set('yaml', 'injections', [[
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'jinja' },
  callback = function()
    vim.o.ts = 4
    vim.o.sw = 4
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
