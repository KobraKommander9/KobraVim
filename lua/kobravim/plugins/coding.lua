local M = {}

M[#M + 1] = {
	"FabijanZulj/blame.nvim",
	cmd = "BlameToggle",
	keys = {
		{ "<leader>gb", "<cmd>BlameToggle<cr>", desc = "Toggle blame" },
	},
	opts = function()
		return {
			mappings = {
				commit_info = KobraVim.keys.extra.info,
			},
		}
	end,
}

-- better a/i textobjects
M[#M + 1] = {
	"nvim-mini/mini.ai",
	event = "VeryLazy",
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				i = KobraVim.mini.ai_indent, -- indent
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
		}
	end,
}

M[#M + 1] = {
	"folke/ts-comments.nvim",
	event = "VeryLazy",
	config = true,
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
