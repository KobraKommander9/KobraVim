local M = {}

local function setup(_, opts)
	for _, key in ipairs({ "format_on_save", "format_after_save" }) do
		if opts[key] then
			local msg =
				"Don't set `opts.%s` for `conform.nvim`.\n**KobraVim** will use the conform formatter automatically"
			KobraVim.warn(msg:format(key))
			opts[key] = nil
		end
	end

	if opts.format then
		KobraVim.warn("**conform.nvim** `opts.format` is deprecated. Please use `opts.default_format_opts` instead.")
	end

	require("conform").setup(opts)
end

M[#M + 1] = {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	init = function()
		KobraVim.on_very_lazy(function()
			KobraVim.format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end)
	end,
	opts = function()
		local plugin = require("lazy.core.config").plugins["conform.nvim"]
		if plugin.config ~= setup then
			KobraVim.error({
				"Don't set `plugin.config` for `conform.nvim`.\n",
				"This will break **KobraVim** formatting",
			}, { title = "KobraVim" })
		end

		return {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		}
	end,
	config = setup,
}

return M
