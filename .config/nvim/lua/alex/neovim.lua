--------------------
-- Neovim options --
--------------------

-- Do not show the current mode in cmdline.
vim.cmd('set noshowmode')

-- Clipboard.
vim.cmd('set clipboard+=unnamedplus')

-- Enable mouse input.
vim.cmd('set mouse=a')

-- Syntax.
vim.cmd('set number')
vim.cmd('set relativenumber')
vim.cmd('set cursorline')
vim.cmd('set cursorlineopt=both')
vim.cmd('set hlsearch')
vim.cmd('set ignorecase')
vim.cmd('set smartcase')

-- Setup tabbing.
vim.cmd('set tabstop	=4')
vim.cmd('set softtabstop=4')
vim.cmd('set shiftwidth =4')
vim.cmd('set textwidth	=0')
vim.cmd('set expandtab')
vim.cmd('set autoindent')

-- Show matching brackets.
vim.cmd('set showmatch')

-- Disable text wrap around.
vim.cmd('set nowrap')

-- Make the cmdline disappear when not in use.
vim.cmd('set cmdheight=0')

-- Disable VM exit message and statusline.
vim.g.VM_set_statusline = 0
vim.g.VM_silent_exit = 1

-- Neovim fill characters.

--[[ Defaults:
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
--]]
vim.opt.fillchars = {
  -- horiz = '―',
  -- horizup = '―',
  horiz = '⎯',
  horizup = '⎯',
  horizdown = '⎯',
  vert = ' ',
  vertleft  = ' ',
  vertright = ' ',
  verthoriz = ' ',
  eob = ' ',
}
