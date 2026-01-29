local M = {}

function M.setup()
	require("heirline").load_colors(KobraVim.bars.palette.build())

	vim.api.nvim_create_augroup("Heirline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			require("heirline.utils").on_colorscheme(KobraVim.bars.palette.build())
		end,
		group = "Heirline",
	})
end

function M.statusline()
	local components = KobraVim.bars.components
	local palette = KobraVim.bars.palette
	local utils = require("heirline.utils")

	local ModeBlock = utils.surround({ "", "" }, palette.get_mode_color, {
		components.mode,
		hl = { fg = "bg" },
	})

	local FileBlock = {
		{
			provider = "",
			hl = { fg = "bg", bg = "func" },
		},
		{
			components.file,
			hl = { fg = "bg", bg = "func" },
		},
		{
			provider = "",
			hl = { fg = "func", bg = "bg" },
		},
	}

	local LspBlock = {
		{
			provider = "",
			hl = { fg = "bg_bright", bg = "bg" },
		},
		{
			components.lsp.status,
			hl = { bg = "bg_bright" },
		},
		{
			provider = "",
			hl = { fg = "error", bg = "bg_bright" },
		},
		{
			components.lsp.error,
			hl = { fg = "bg", bg = "error" },
		},
		{
			provider = "",
			hl = { fg = "warn", bg = "error" },
		},
		{
			components.lsp.warn,
			hl = { fg = "bg", bg = "warn" },
		},
		{
			provider = "",
			hl = { fg = "info", bg = "warn" },
		},
		{
			components.lsp.info,
			hl = { fg = "bg", bg = "info" },
		},
		{
			provider = "",
			hl = { fg = "hint", bg = "info" },
		},
		{
			components.lsp.hint,
			hl = { fg = "bg", bg = "hint" },
		},
		{
			provider = "",
			hl = { fg = "bg", bg = "hint" },
		},
	}

	local RulerBlock = {
		{
			provider = "",
			hl = function()
				return {
					fg = palette.get_mode_color(),
					bg = "bg",
				}
			end,
		},
		{
			components.ruler,
			hl = function()
				return {
					fg = "bg",
					bg = palette.get_mode_color(),
				}
			end,
		},
		{
			provider = "",
			hl = function()
				return {
					fg = palette.get_mode_color(),
				}
			end,
		},
	}

	return {
		ModeBlock,
		components.git,
		FileBlock,
		{ provider = "%=" },
		LspBlock,
		components.journal,
		RulerBlock,
	}
end

function M.tabline()
	local components = KobraVim.bars.components
	local utils = require("heirline.utils")

	local Tabpage = {
		provider = "",
		hl = function(self)
			if not self.is_active then
				return { fg = "bg", bg = "bg_bright" }
			else
				return { fg = "bg", bg = "func" }
			end
		end,

		components.tab,

		{
			provider = "",
		},
	}

	return utils.make_tablist(Tabpage)
end

return KobraVim.make_package(M, "kobravim.util.bars")
