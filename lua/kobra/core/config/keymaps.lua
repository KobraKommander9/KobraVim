local Keys = require("kobra.core.keys")
local map = KobraVim.keymap

if require("kobra.core").layouts.colemak then
	-- N goes to the next match (replaces n)
	-- E goes to previous match (replaces N)
	-- I moves cursor to bottom of screen

	-- l to insert mode
	-- L to insert at beginning of line

	-- K/k replaces E/e
	-- previous word (B) and end of word (K) are next to each other

	-- Help is on lower case j

	local key_opts = { silent = true, noremap = true }
	map("", "n", "j", key_opts)
	map("", "N", "n", key_opts)
	map("", "e", "k", key_opts)
	map("", "E", "N", key_opts)
	map("", "i", "l", key_opts)
	map("", "I", "L", key_opts)
	map("", "j", "K", key_opts)
	map("", "k", "e", key_opts)
	map("", "K", "E", key_opts)
	map("", "l", "i", key_opts)
	map("", "L", "I", key_opts)
end

-- better paste
map("v", "p", '"_dP', { silent = true })

-- better up/down
map("n", Keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
map("n", Keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-" .. Keys.j .. ">", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-" .. Keys.k .. ">", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-" .. Keys.l .. ">", "<C-w>l", { desc = "Go to right window" })

-- clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- clear search, diff update, and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
	{ desc = "Clear search, diff update, and redraw" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, Keys.nextMatch, "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, Keys.prevMatch, "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- toggle options
-- map("n", "<leader>uf", require("kobra.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })

map("n", "<leader>us", function()
	KobraVim.toggle("spell")
end, { desc = "Toggle Spelling" })

map("n", "<leader>uw", function()
	KobraVim.toggle("wrap")
end, { desc = "Toggle Word Wrap" })

map("n", "<leader>ul", function()
	KobraVim.toggle("relativenumber", true)
	KobraVim.toggle("number")
end, { desc = "Toggle Line Numbers" })

map("n", "<leader>ud", KobraVim.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
	KobraVim.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

map("n", "<leader>ua", function()
	KobraVim.toggle("autochdir")
end, { desc = "Toggle Autochdir" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quit
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>ws", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>wv", "<C-W>v", { desc = "Split window right" })

-- tabs
map("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>am" .. Keys.j, "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
map("n", "<leader>am" .. Keys.k, "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
map("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
map("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
