local M = {}

M[#M + 1] = {
	"stevearc/dressing.nvim",
	lazy = true,
	init = function()
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
}

M[#M + 1] = {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	config = function()
		require("heirline").setup({
			statusline = require("kobra.core.config.ui.lines.statusline").statusline(),
			winbar = require("kobra.core.config.ui.lines.winbar").winbar(),
			-- tabline = require('kobra.core.config.ui.lines.tabline').tabline(),
			opts = {
				disable_winbar_cb = function(args)
					return require("heirline.conditions").buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix" },
						filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
					}, args.buf)
				end,
			},
		})
	end,
}

M[#M + 1] = {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function(_, opts)
		local options = vim.tbl_deep_extend("force", require("kobra.core.config.ui.start-screen").config, opts)

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(options)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				require("kobra.core.config.ui.start-screen").section.footer.val = "⚡ Neovim loaded "
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}

return M
