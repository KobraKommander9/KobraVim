local Keys = require("kobra.core.keys")

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys

	-- do not create keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local opts = { silent = true, noremap = true }
map("", "j", Keys.j, opts)
map("", "k", Keys.k, opts)
map("", "l", Keys.l, opts)

map("", "J", Keys.J, opts)
map("", "K", Keys.K, opts)
map("", "L", Keys.L, opts)

map("", "n", Keys.n, opts)
map("", "e", Keys.e, opts)
map("", "i", Keys.i, opts)

map("", "N", Keys.N, opts)
map("", "E", Keys.E, opts)
map("", "I", Keys.I, opts)

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

-- move lines
--[[
map("n", "<A-" .. Keys.j .. ">", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-" .. Keys.k .. ">", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-" .. Keys.j .. ">", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-" .. Keys.k .. ">", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-" .. Keys.j .. ">", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-" .. Keys.k .. ">", ":m '<-2<cr>gv=gv", { desc = "Move up" })
--]]

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
map({ "n", "x", "o" }, Keys.n, "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, Keys.N, "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
--[[
map("v", "<", "<gv")
map("v", ">", ">gv")
--]]

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- toggle options
map("n", "<leader>uf", require("kobra.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })

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
--[[
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>wb", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>wr", "<C-W>v", { desc = "Split window right" })
--]]

-- tabs
map("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>amn", "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
map("n", "<leader>amp", "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
map("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
map("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
