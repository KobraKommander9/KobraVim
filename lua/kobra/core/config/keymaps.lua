local layout = require('kobra.core.globals').layout

local function map(mode, lhs, rhs, opts)
  local keys = require('lazy.core.handler').handers.keys

  -- do not create keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local keys = {
  j = 'j',
  k = 'k',
  l = 'l',
  n = 'n',
  e = 'e',
  i = 'i',
}

if layout.colemak then
  keys.j = 'n'
  keys.k = 'e'
  keys.l = 'i'
  keys.n = 'j'
  keys.e = 'k'
  keys.i = 'l'

  local opts = { silent = true, noremap = true }
  map('', 'n', 'j', opts)
  map('', 'e', 'k', opts)
  map('', 'i', 'l', opts)
  map('', 'j', 'n', opts)
  map('', 'k', 'e', opts)
  map('', 'l', 'i', opts)

  -- this one is mainly for copilot
  map('', '<C-t>', '<C-i>', opts)
end

-- better up/down
map('n', keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
map('n', keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
map('n', '<C-' .. keys.h .. '>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-' .. keys.j .. '>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-' .. keys.k .. '>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-' .. keys.l .. '>', '<C-w>l', { desc = 'Go to right window' })

-- move lines
map('n', '<A-' .. keys.j .. '>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-' .. keys.k .. '>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-' .. keys.j .. '>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-' .. keys.k .. '>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-' .. keys.j .. '>', ':m ">+1<cr>gv=gv', { desc = 'Move down' })
map('v', '<A-' .. keys.k .. '>', ':m "<-2<cr>gv=gv', { desc = 'Move up' })

-- clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

map({ 'n', 'x' }, 'gw', '*N', { desc = 'Search word under cursor' })

-- save file
map({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- new file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- quit
map('n', '<leader>q!', '<cmd>q<cr>', { desc = 'Quit' })
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- windows
map('n', '<leader>ww', '<C-W>p', { desc = 'Other window' })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete window' })
map('n', '<leader>wb', '<C-W>s', { desc = 'Split window below' })
map('n', '<leader>wr', '<C-W>v', { desc = 'Split window right' })

-- tabs
map('n', '<leader>al', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader>af', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader>aa', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader>an', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader>ac', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader>ap', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
