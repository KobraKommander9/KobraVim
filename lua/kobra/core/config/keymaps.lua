local layouts = require("kobra.core").layouts

local Keys = require("kobra.core.keys")
local Util = require("kobra.util")

if layouts.colemak then
	-- N goes to the next match (replaces n)
	-- E goes to previous match (replaces N)
	-- I moves cursor to bottom of screen

	-- l to insert mode
	-- L to insert at beginning of line

	-- K/k replaces E/e
	-- previous word (B) and end of word (K) are next to each other

	-- Help is on lower case j

	local key_opts = { silent = true, noremap = true }
	Util.keymap("", "n", "j", key_opts)
	Util.keymap("", "N", "n", key_opts)
	Util.keymap("", "e", "k", key_opts)
	Util.keymap("", "E", "N", key_opts)
	Util.keymap("", "i", "l", key_opts)
	Util.keymap("", "I", "L", key_opts)
	Util.keymap("", "j", "K", key_opts)
	Util.keymap("", "k", "e", key_opts)
	Util.keymap("", "K", "E", key_opts)
	Util.keymap("", "l", "i", key_opts)
	Util.keymap("", "L", "I", key_opts)
end

-- better paste
Util.keymap("v", "p", '"_dP', { silent = true })

-- better up/down
Util.keymap("n", Keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
Util.keymap("n", Keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
Util.keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
Util.keymap("n", "<C-" .. Keys.j .. ">", "<C-w>j", { desc = "Go to lower window" })
Util.keymap("n", "<C-" .. Keys.k .. ">", "<C-w>k", { desc = "Go to upper window" })
Util.keymap("n", "<C-" .. Keys.l .. ">", "<C-w>l", { desc = "Go to right window" })

-- move lines
Util.keymap("n", "<A-" .. Keys.j .. ">", "<cmd>m .+1<cr>==", { desc = "Move down" })
Util.keymap("n", "<A-" .. Keys.k .. ">", "<cmd>m .-2<cr>==", { desc = "Move up" })
Util.keymap("i", "<A-" .. Keys.j .. ">", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
Util.keymap("i", "<A-" .. Keys.k .. ">", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
Util.keymap("v", "<A-" .. Keys.j .. ">", ":m '>+1<cr>gv=gv", { desc = "Move down" })
Util.keymap("v", "<A-" .. Keys.k .. ">", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- clear search with <esc>
Util.keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- clear search, diff update, and redraw
-- taken from runtime/lua/_editor.lua
Util.keymap(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
	{ desc = "Clear search, diff update, and redraw" }
)

Util.keymap({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
Util.keymap({ "n", "x", "o" }, Keys.nextMatch, "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
Util.keymap({ "n", "x", "o" }, Keys.prevMatch, "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
Util.keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
Util.keymap("v", "<", "<gv")
Util.keymap("v", ">", ">gv")

-- lazy
Util.keymap("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
Util.keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

--[[
Util.keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
Util.keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
--]]

-- toggle options
-- Util.keymap("n", "<leader>uf", require("kobra.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })

Util.keymap("n", "<leader>us", function()
	KobraVim.toggle("spell")
end, { desc = "Toggle Spelling" })

Util.keymap("n", "<leader>uw", function()
	KobraVim.toggle("wrap")
end, { desc = "Toggle Word Wrap" })

Util.keymap("n", "<leader>ul", function()
	KobraVim.toggle("relativenumber", true)
	KobraVim.toggle("number")
end, { desc = "Toggle Line Numbers" })

Util.keymap("n", "<leader>ud", KobraVim.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
Util.keymap("n", "<leader>uc", function()
	KobraVim.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

Util.keymap("n", "<leader>ua", function()
	KobraVim.toggle("autochdir")
end, { desc = "Toggle Autochdir" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	Util.keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quit
Util.keymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
Util.keymap("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- tabs
Util.keymap("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
Util.keymap("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
Util.keymap("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
Util.keymap("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
Util.keymap("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
Util.keymap("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
Util.keymap("n", "<leader>amn", "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
Util.keymap("n", "<leader>amp", "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
Util.keymap("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
Util.keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
Util.keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
Util.keymap("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
