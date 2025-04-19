local map = KobraVim.keys.safe_map

-- remap keys
for lhs, rhs in pairs(KobraVim.keys.mappings()) do
	map("", lhs, rhs, { silent = true, noremap = true })
	map("", rhs, lhs, { silent = true, noremap = true })
end

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, KobraVim.keys.nextMatch, "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, KobraVim.keys.prevMatch, "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- better paste
map("v", "p", '"_dP', { silent = true })

-- better up/down
map("n", KobraVim.keys.j, 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })
map("n", KobraVim.keys.k, 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })

-- move lines
map("n", "<A-" .. KobraVim.keys.j .. ">", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-" .. KobraVim.keys.k .. ">", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-" .. KobraVim.keys.j .. ">", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-" .. KobraVim.keys.k .. ">", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-" .. KobraVim.keys.j .. ">", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-" .. KobraVim.keys.k .. ">", ":m '<-2<cr>gv=gv", { desc = "Move up" })

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

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- lazy
map("n", "<leader>cl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- toggle options
KobraVim.toggle.map("<leader>ua", KobraVim.toggle("autochdir", { name = "Auto Change Dir" }))
KobraVim.toggle.map(
	"<leader>uc",
	KobraVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } })
)
KobraVim.toggle.map("<leader>ud", KobraVim.toggle.diagnostics)
-- KobraVim.toggle.map("<leader>uf", KobraVim.toggle.format())
-- KobraVim.toggle.map("<leader>uF", KobraVim.toggle.format(true))
KobraVim.toggle.map("<leader>ul", KobraVim.toggle.number)
KobraVim.toggle.map("<leader>uL", KobraVim.toggle("relativenumber", { name = "Relative Number" }))
KobraVim.toggle.map("<leader>us", KobraVim.toggle("spell", { name = "Spelling" }))
KobraVim.toggle.map("<leader>uT", KobraVim.toggle.treesitter)
KobraVim.toggle.map("<leader>uw", KobraVim.toggle("wrap", { name = "Wrap" }))

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quit
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wN", "<C-w>n", { desc = "New window" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window right" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-" .. KobraVim.keys.j .. ">", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-" .. KobraVim.keys.k .. ">", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-" .. KobraVim.keys.l .. ">", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>w" .. KobraVim.keys.j, "<C-W>j", { desc = "Go to lower window" })
map("n", "<leader>w" .. KobraVim.keys.k, "<C-W>k", { desc = "Go to upper window" })
map("n", "<leader>w" .. KobraVim.keys.l, "<C-W>l", { desc = "Go to right window" })

map("n", "<leader>wH", "<C-w>H", { desc = "Swap layout left" })
map("n", "<leader>w" .. KobraVim.keys.J, "<C-w>H", { desc = "Swap layout left" })

map("n", "<leader>wb", "<C-w>b", { desc = "Cursor bottom-most" })
map("n", "<leader>wp", "<C-w>p", { desc = "Previous window" })
map("n", "<leader>wt", "<C-w>t", { desc = "Cursor top-most" })
map("n", "<leader>ww", "<C-w>w", { desc = "Window below" })
map("n", "<leader>wW", "<C-w>W", { desc = "Window above" })

map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows right" })
map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows left" })
map("n", "<leader>wx", "<C-w>x", { desc = "Exchange next window" })

map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>w-", "<C-w>-", { desc = "Decrease height" })
map("n", "<leader>w+", "<C-w>+", { desc = "Increase height" })
map("n", "<leader>w_", "<C-w>+", { desc = "Maximize height" })
map("n", "<leader>w<", "<C-w><", { desc = "Decrease width" })
map("n", "<leader>w>", "<C-w>>", { desc = "Increase width" })
map("n", "<leader>w|", "<C-w>|", { desc = "Maximize width" })

-- tabs
map("n", "<leader>al", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>af", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>aa", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>an", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>ac", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>ap", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>am" .. KobraVim.keys.j, "<cmd>+tabmove<cr>", { desc = "Move Current Tab to Next" })
map("n", "<leader>am" .. KobraVim.keys.k, "<cmd>-tabmove<cr>", { desc = "Move Current Tab to Previous" })

-- diagnostics
map("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Hover Diagnostic" })
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
map("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>", { desc = "Quickfix Diagnostic" })
