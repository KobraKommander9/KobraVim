local M = {}

M[#M + 1] = {
	"echasnovski/mini.fuzzy",
	lazy = true,
	config = true,
}

M[#M + 1] = {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()
		local auto_select = true

		return {
			auto_brackets = {}, -- configure any filetype to auto add brackets
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-c>"] = cmp.mapping.close(),
				["<CR>"] = Kobra.cmp.confirm({ select = auto_select }),
				["<C-y>"] = Kobra.cmp.confirm({ select = true }),
				["<S-CR>"] = Kobra.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				["<C-" .. Kobra.keys.j .. ">"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-" .. Kobra.keys.k .. ">"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
			formatting = {
				format = function(_, item)
					local icons = Kobra.config.icons.kinds
					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end

					local widths = {
						abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
						menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
					}

					for key, width in pairs(widths) do
						if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
							item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
						end
					end

					return item
				end,
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			sorting = defaults.sorting,
		}
	end,
	main = "kobra.util.cmp",
}

-- snippets
M[#M + 1] = {
	"nvim-cmp",
	dependencies = {
		{
			"garymjr/nvim-snippets",
			opts = {
				friendly_snippets = true,
			},
			dependencies = { "rafamadriz/friendly-snippets" },
		},
	},
	keys = {
		{
			"<Tab>",
			function()
				return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
			end,
			expr = true,
			silent = true,
			mode = { "i", "s" },
		},
		{
			"<S-Tab>",
			function()
				return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
			end,
			expr = true,
			silent = true,
			mode = { "i", "s" },
		},
	},
	opts = function(_, opts)
		opts.snippet = {
			expand = function(item)
				return Kobra.cmp.expand(item.body)
			end,
		}
		if Kobra.has("nvim-snippets") then
			table.insert(opts.sources, { name = "snippets" })
		end
	end,
}

return M
