local M = {}

local components = require("kobra.util.heirline.components")

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.heirline." .. key)
		return t[key]
	end,
})

function M.setup()
	local utils = require("heirline.utils")
	local group = vim.api.nvim_create_augroup("KobraLines", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			utils.on_colorscheme(KobraColors.create_hl_groups())
		end,
	})
end

function M.statusline()
	return {
		components.mode.component(),
	}
end

function M.tabline()
	return {}
end

function M.winbar()
	return {}
end

return M
