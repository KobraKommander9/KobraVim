local M = {}

M[#M + 1] = {
	"L3MON4D3/LuaSnip",
	event = "VeryLazy",
	build = (not jit.os:find("Windows"))
			and [[ echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp ]]
		or nil,
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
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
		"hrsh7th/cmp-calc",
		"f3fora/cmp-spell",
		"saadparwaiz1/cmp_luasnip",
		"petertriho/cmp-git",
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
				["<C-e>"] = cmp.mapping.close(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			}),
			sources = cmp.config.sources({
				{ name = "rg" },
				{ name = "nvim_lua" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "luasnip" },
				{ name = "calc" },
				{ name = "path" },
				{ name = "spell" },
			}, {
				{ name = "buffer" },
			}),
			formatting = {
				format = function(_, item)
					local icons = require("kobra.core").icons.kinds
					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end
					return item
				end,
			},
		}

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" },
			}, {
				{ name = "buffer" },
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
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
		})

		return opts
	end,
}

M[#M + 1] = {
	"echasnovski/mini.pairs",
	event = "VeryLazy",
	config = function(_, opts)
		require("mini.pairs").setup(opts)
	end,
}

M[#M + 1] = {
	"echasnovski/mini.surround",
	keys = function(_, keys)
		-- Populate the keys based on the user's options
		local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
		local opts = require("lazy.core.plugin").values(plugin, "opts", false)
		local mappings = {
			{ opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
			{ opts.mappings.delete, desc = "Delete surrounding" },
			{ opts.mappings.find, desc = "Find right surrounding" },
			{ opts.mappings.find_left, desc = "Find left surrounding" },
			{ opts.mappings.highlight, desc = "Highlight surrounding" },
			{ opts.mappings.replace, desc = "Replace surrounding" },
			{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	opts = {
		mappings = {
			add = "gza", -- Add surrounding in Normal and Visual modes
			delete = "gzd", -- Delete surrounding
			find = "gzf", -- Find surrounding (to the right)
			find_left = "gzF", -- Find surrounding (to the left)
			highlight = "gzh", -- Highlight surrounding
			replace = "gzr", -- Replace surrounding
			update_n_lines = "gzn", -- Update `n_lines`
		},
	},
	config = function(_, opts)
		-- use gz mappings instead of s to prevent conflict with leap
		require("mini.surround").setup(opts)
	end,
}

M[#M + 1] = { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true }

M[#M + 1] = {
	"echasnovski/mini.comment",
	event = "VeryLazy",
	opts = {
		hooks = {
			pre = function()
				require("ts_context_commentstring.internal").update_commentstring({})
			end,
		},
	},
	config = function(_, opts)
		require("mini.comment").setup(opts)
	end,
}

M[#M + 1] = {
	"echasnovski/mini.ai",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter-textobjects" },
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}, {}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
			},
		}
	end,
	config = function(_, opts)
		require("mini.ai").setup(opts)
		-- register all text objects with which-key
		if KobraVim.has("which-key.nvim") then
			---@type table<string, string|table>
			local i = {
				[" "] = "Whitespace",
				['"'] = 'Balanced "',
				["'"] = "Balanced '",
				["`"] = "Balanced `",
				["("] = "Balanced (",
				[")"] = "Balanced ) including white-space",
				[">"] = "Balanced > including white-space",
				["<lt>"] = "Balanced <",
				["]"] = "Balanced ] including white-space",
				["["] = "Balanced [",
				["}"] = "Balanced } including white-space",
				["{"] = "Balanced {",
				["?"] = "User Prompt",
				_ = "Underscore",
				a = "Argument",
				b = "Balanced ), ], }",
				c = "Class",
				f = "Function",
				o = "Block, conditional, loop",
				q = "Quote `, \", '",
				t = "Tag",
			}
			local a = vim.deepcopy(i)
			for k, v in pairs(a) do
				a[k] = v:gsub(" including.*", "")
			end

			local ic = vim.deepcopy(i)
			local ac = vim.deepcopy(a)
			for key, name in pairs({ n = "Next", l = "Last" }) do
				i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
				a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
			end

			require("which-key").register({
				mode = { "o", "x" },
				i = i,
				a = a,
			})
		end
	end,
}

return M
