local M = {}

local Plugin = require("lazy.core.plugin")

M.renames = {
	["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
	["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
	["null-ls.nvim"] = "none-ls.nvim",
	["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
}

function M.fix_renames()
	Plugin.Spec.add = KobraVim.inject.args(Plugin.Spec.add, function(self, plugin)
		if type(plugin) == "table" then
			if M.renames[plugin[1]] then
				KobraVim.warn(
					("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
						plugin[1],
						M.renames[plugin[1]],
						self.importing or "KobraVim"
					),
					{ title = "KobraVim" }
				)
				plugin[1] = M.renames[plugin[1]]
			end
		end
	end)
end

function M.setup()
	M.fix_renames()
end

return M
