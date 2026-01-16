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
  pattern = { 'bash', 'haskell', 'vim' },
  callback = function()
    vim.treesitter.start()
    vim.o.ts = 4
    vim.o.sw = 4
    vim.o.et = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'lua', 'nix' },
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
