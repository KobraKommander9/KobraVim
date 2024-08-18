local layouts = require("kobra.core").layouts

local Keys = require("kobra.core.keys")

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
	KobraVim.keymap("", "n", "j", key_opts)
	KobraVim.keymap("", "N", "n", key_opts)
	KobraVim.keymap("", "e", "k", key_opts)
	KobraVim.keymap("", "E", "N", key_opts)
	KobraVim.keymap("", "i", "l", key_opts)
	KobraVim.keymap("", "I", "L", key_opts)
	KobraVim.keymap("", "j", "K", key_opts)
	KobraVim.keymap("", "k", "e", key_opts)
	KobraVim.keymap("", "K", "E", key_opts)
	KobraVim.keymap("", "l", "i", key_opts)
	KobraVim.keymap("", "L", "I", key_opts)
end

-- better paste
KobraVim.keymap("v", "p", '"_dP', { silent = true })

-- better up/down
KobraVim.keymap("n", Keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
KobraVim.keymap("n", Keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
KobraVim.keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
KobraVim.keymap("n", "<C-" .. Keys.j .. ">", "<C-w>j", { desc = "Go to lower window" })
KobraVim.keymap("n", "<C-" .. Keys.k .. ">", "<C-w>k", { desc = "Go to upper window" })
KobraVim.keymap("n", "<C-" .. Keys.l .. ">", "<C-w>l", { desc = "Go to right window" })

-- move lines
KobraVim.keymap("n", "<A-" .. Keys.j .. ">", "<cmd>m .+1<cr>==", { desc = "Move down" })
KobraVim.keymap("n", "<A-" .. Keys.k .. ">", "<cmd>m .-2<cr>==", { desc = "Move up" })
KobraVim.keymap("i", "<A-" .. Keys.j .. ">", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
KobraVim.keymap("i", "<A-" .. Keys.k .. ">", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
KobraVim.keymap("v", "<A-" .. Keys.j .. ">", ":m '>+1<cr>gv=gv", { desc = "Move down" })
KobraVim.keymap("v", "<A-" .. Keys.k .. ">", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- clear search with <esc>
KobraVim.keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- clear search, diff update, and redraw
-- taken from runtime/lua/_editor.lua
KobraVim.keymap(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
	{ desc = "Clear search, diff update, and redraw" }
)

KobraVim.keymap({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
KobraVim.keymap(
	{ "n", "x", "o" },
	Keys.nextMatch,
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
KobraVim.keymap(
	{ "n", "x", "o" },
	Keys.prevMatch,
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)

-- save file
KobraVim.keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
KobraVim.keymap("v", "<", "<gv")
KobraVim.keymap("v", ">", ">gv")

-- lazy
KobraVim.keymap("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
KobraVim.keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

--[[
KobraVim.keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
KobraVim.keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
--]]

-- toggle options
-- KobraVim.keymap("n", "<leader>uf", require("kobra.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })

KobraVim.keymap("n", "<leader>us", function()
	KobraVim.toggle("spell")
end, { desc = "Toggle Spelling" })

KobraVim.keymap("n", "<leader>uw", function()
	KobraVim.toggle("wrap")
end, { desc = "Toggle Word Wrap" })

KobraVim.keymap("n", "<leader>ul", function()
	KobraVim.toggle("relativenumber", true)
	KobraVim.toggle("number")
end, { desc = "Toggle Line Numbers" })

KobraVim.keymap("n", "<leader>ud", KobraVim.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
KobraVim.keymap("n", "<leader>uc", function()
	KobraVim.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

KobraVim.keymap("n", "<leader>ua", function()
	KobraVim.toggle("autochdir")
end, { desc = "Toggle Autochdir" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	KobraVim.keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quit
KobraVim.keymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
KobraVim.keymap("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
KobraVim.keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
KobraVim.keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
KobraVim.keymap("n", "<leader>ws", "<C-W>s", { desc = "Split window below" })
KobraVim.keymap("n", "<leader>wv", "<C-W>v", { desc = "Split window right" })

-- tabs
KobraVim.keymap("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
KobraVim.keymap("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
KobraVim.keymap("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
KobraVim.keymap("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
KobraVim.keymap("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
KobraVim.keymap("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
KobraVim.keymap("n", "<leader>am" .. Keys.j, "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
KobraVim.keymap("n", "<leader>am" .. Keys.k, "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
KobraVim.keymap("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
KobraVim.keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
KobraVim.keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
KobraVim.keymap("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
