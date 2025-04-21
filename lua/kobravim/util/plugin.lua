local M = {}

local Plugin = require("lazy.core.plugin")

M.kobra_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

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

function M.kobra_file()
	local Event = require("lazy.core.handler.event")
	Event.mappings.KobraFile = { id = "KobraFile", event = M.kobra_file_events }
	Event.mappings["User KobraFile"] = Event.mappings.KobraFile
end

function M.setup()
	M.fix_renames()
	M.kobra_file()
end

return M
