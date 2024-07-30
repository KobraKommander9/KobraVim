local Keys = require("kobra.core.keys")
local Util = require("kobra.util")

-- better paste
Util.lazymap("v", "p", '"_dP', { silent = true })

-- better up/down
Util.lazymap("n", Keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
Util.lazymap("n", Keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
--[[
Util.lazymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
Util.lazymap("n", "<C-" .. Keys.j .. ">", "<C-w>j", { desc = "Go to lower window" })
Util.lazymap("n", "<C-" .. Keys.k .. ">", "<C-w>k", { desc = "Go to upper window" })
Util.lazymap("n", "<C-" .. Keys.l .. ">", "<C-w>l", { desc = "Go to right window" })
--]]

-- move lines
--[[
Util.lazymap("n", "<A-" .. Keys.j .. ">", "<cmd>m .+1<cr>==", { desc = "Move down" })
Util.lazymap("n", "<A-" .. Keys.k .. ">", "<cmd>m .-2<cr>==", { desc = "Move up" })
Util.lazymap("i", "<A-" .. Keys.j .. ">", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
Util.lazymap("i", "<A-" .. Keys.k .. ">", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
Util.lazymap("v", "<A-" .. Keys.j .. ">", ":m '>+1<cr>gv=gv", { desc = "Move down" })
Util.lazymap("v", "<A-" .. Keys.k .. ">", ":m '<-2<cr>gv=gv", { desc = "Move up" })
--]]

-- clear search with <esc>
Util.lazymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- clear search, diff update, and redraw
-- taken from runtime/lua/_editor.lua
Util.lazymap(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
	{ desc = "Clear search, diff update, and redraw" }
)

Util.lazymap({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
Util.lazymap({ "n", "x", "o" }, Keys.nextMatch, "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
Util.lazymap({ "n", "x", "o" }, Keys.prevMatch, "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
Util.lazymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
Util.lazymap("v", "<", "<gv")
Util.lazymap("v", ">", ">gv")

-- lazy
Util.lazymap("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
-- Util.lazymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

--[[
Util.lazymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
Util.lazymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
--]]

-- toggle options
-- Util.lazymap("n", "<leader>uf", require("kobra.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })

Util.lazymap("n", "<leader>us", function()
	KobraVim.toggle("spell")
end, { desc = "Toggle Spelling" })

Util.lazymap("n", "<leader>uw", function()
	KobraVim.toggle("wrap")
end, { desc = "Toggle Word Wrap" })

Util.lazymap("n", "<leader>ul", function()
	KobraVim.toggle("relativenumber", true)
	KobraVim.toggle("number")
end, { desc = "Toggle Line Numbers" })

Util.lazymap("n", "<leader>ud", KobraVim.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
Util.lazymap("n", "<leader>uc", function()
	KobraVim.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

Util.lazymap("n", "<leader>ua", function()
	KobraVim.toggle("autochdir")
end, { desc = "Toggle Autochdir" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	Util.lazymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quit
Util.lazymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
Util.lazymap("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
--[[
Util.lazymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
Util.lazymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
Util.lazymap("n", "<leader>wb", "<C-W>s", { desc = "Split window below" })
Util.lazymap("n", "<leader>wr", "<C-W>v", { desc = "Split window right" })
--]]

-- tabs
Util.lazymap("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
Util.lazymap("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
Util.lazymap("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
Util.lazymap("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
Util.lazymap("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
Util.lazymap("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
Util.lazymap("n", "<leader>amn", "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
Util.lazymap("n", "<leader>amp", "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
Util.lazymap("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
Util.lazymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
Util.lazymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
Util.lazymap("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
