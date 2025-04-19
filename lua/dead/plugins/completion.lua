local M = {}

M[#M + 1] = {
	"github/copilot.vim",
	command = "Copilot",
	build = ":Copilot setup",
	config = function()
		vim.cmd('imap <silent><script><expr> <c-t> copilot#Accept("<CR>")')
	end,
}

M[#M + 1] = {
	"L3MON4D3/LuaSnip",
	lazy = true,
	build = "make install_jsregexp",
}

M[#M + 1] = {
	"saadparwaiz1/cmp_luasnip",
	lazy = true,
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
}

M[#M + 1] = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
	},
	opts = function()
		local cmp = require("cmp")
		local opts = {
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				[Kobra.keys.cycleDown] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				[Kobra.keys.cycleUp] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
			formatting = {
				format = function(_, item)
					if Kobra.config.icons[item.kind] then
						item.kind = Kobra.config.icons[item.kind] .. item.kind
					end
					return item
				end,
			},
		}

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.present.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		return opts
	end,
}

return M
