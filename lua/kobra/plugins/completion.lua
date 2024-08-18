local M = {}

-- completion
M[#M + 1] = {
	"echasnovski/mini.completion",
	event = "VeryLazy",
	opts = {
		-- lsp_completion = {
		-- 	source_func = "omnifunc",
		-- 	auto_setup = false,
		-- },
	},
}

return M
