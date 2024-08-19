local M = {}

function M.setup(opts)
	local MiniClue = require("mini.clue")
	local config = vim.tbl_deep_extend("force", MiniClue.config or {}, opts)
	MiniClue.setup(config)
end

setmetatable(M, {
	__call = function(m, opts)
		KobraVim.on_load("mini.clue", function()
			m.setup(opts)
		end)
	end,
})

return M
