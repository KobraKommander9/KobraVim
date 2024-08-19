local M = {}

local Plugin = require("lazy.core.plugin")

M.core_imports = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

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

function M.lazy_file()
	vim.api.nvim_create_autocmd("BufReadPost", {
		once = true,
		callback = function(event)
			if vim.v.vim_did_enter == 1 then
				return
			end

			local ft = vim.filetype.match({ buf = event.buf })
			if ft then
				local lang = vim.treesitter.language.get_lang(ft)
				if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
					vim.bo[event.buf].syntax = ft
				end

				vim.cmd([[redraw]])
			end
		end,
	})

	local Event = require("lazy.core.handler.event")
	Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.setup()
	M.fix_renames()
	M.lazy_file()
end

return M
