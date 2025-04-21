local M = {}

M[#M + 1] = {
	"saghen/blink.cmp",
	version = "*",
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default",
	},
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"saghen/blink.compat",
			optional = true,
			opts = {},
			verson = "*",
		},
	},
	event = "InsertEnter",
	opts = {
		snippets = {
			expand = function(snippet, _)
				return KobraVim.cmp.expand(snippet)
			end,
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
			},
		},
		sources = {
			compat = {},
			default = { "lsp", "path", "snippets", "buffer" },
		},
		cmdline = {
			enabled = true,
		},
		keymap = {
			preset = "enter",
			["<C-y>"] = { "select_and_accept" },
		},
	},
	config = function(_, opts)
		local enabled = opts.sources.default
		for _, source in ipairs(opts.sources.compat or {}) do
			opts.sources.providers[source] = vim.tbl_deep_extend(
				"force",
				{ name = source, module = "blink.compat.source" },
				opts.sources.providers[source] or {}
			)

			if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
				table.insert(enabled, source)
			end
		end

		if not opts.keymap["<Tab>"] then
			if opts.keymap.preset == "super-tab" then
				opts.keymap["<Tab>"] = {
					require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
					KobraVim.cmp.map({ "snippet_forward", "ai_accept" }),
					"fallback",
				}
			else
				opts.keymap["<Tab>"] = {
					KobraVim.cmp.map({ "snippet_forward", "ai_accept" }),
					"fallback",
				}
			end
		end

		opts.sources.compat = nil

		for _, provider in pairs(opts.sources.providers or {}) do
			if provider.kind then
				local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
				local kind_idx = #CompletionItemKind + 1

				CompletionItemKind[kind_idx] = provider.kind
				CompletionItemKind[provider.kind] = kind_idx

				local transform_items = provider.transform_items
				provider.transform_items = function(ctx, items)
					items = transform_items and transform_items(ctx, items) or items
					for _, item in ipairs(items) do
						item.kind = kind_idx or item.kind
						item.kind_icon = KobraVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
					end
					return items
				end

				provider.kind = nil
			end
		end

		require("blink.cmp").setup(opts)
	end,
}

M[#M + 1] = {
	"saghen/blink.cmp",
	opts = function(_, opts)
		opts.appearance = opts.appearance or {}
		opts.appearance.kind_icons =
			vim.tbl_extend("force", opts.appearance.kind_icons or {}, KobraVim.config.icons.kinds)
	end,
}

M[#M + 1] = {
	"saghen/blink.cmp",
	dependencies = { "lazydev.nvim" },
	opts = {
		sources = {
			default = { "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	},
}

M[#M + 1] = {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "KobraVim", words = { "KobraVim" } },
			{ path = "lazy.nvim", words = { "KobraVim" } },
		},
	},
}

return M
