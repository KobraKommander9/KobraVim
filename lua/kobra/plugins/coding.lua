local M = {}

-- better a/i textobjects
M[#M + 1] = {
	"echasnovski/mini.ai",
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
				i = Kobra.mini.ai_indent, -- indent
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
		}
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
	config = true,
}

return M
