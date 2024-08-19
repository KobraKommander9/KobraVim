local M = {}

vim.uv = vim.uv or vim.loop

_G.KobraVim = require("kobra.util")

function M.setup(opts)
	require("kobra.core").setup(opts)
end

return M
