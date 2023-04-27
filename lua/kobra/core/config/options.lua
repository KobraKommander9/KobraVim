vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.clipboard = 'unnamedplus' -- sync with system clipboard
opt.completeopt = 'menu,menuone,noselect' -- completion options
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- enable highlighting of the current line
opt.expandtab = true -- use spaces instead of tabs
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.grepformat = '%f:%l:%c:%m' -- filename:line:column:error message
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true
opt.inccommand = 'nosplit' -- show effects of a command incrementally
opt.laststatus = 3 -- enable a global statusline
opt.mouse = 'a' -- enable mouse support
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative line numbers
opt.scrolloff = 8
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
opt.shiftwidth = 2 -- size of an indent
opt.shortmess:append('c')
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = 'yes' -- always show the sign column, otherwise it would shift the text each time
opt.smartcase = true
opt.smartindent = true
opt.spelllang = { 'en' }
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wildmode = 'longest:full,full'
opt.winminwidth = 5
opt.wrap = false
opt.autochdir = true
opt.writebackup = false
opt.swapfile = false
opt.backup = false

vim.cmd([[set whichwrap+=<,>,[,],h,l]])
vim.cmd([[set iskeyword+=1]])
