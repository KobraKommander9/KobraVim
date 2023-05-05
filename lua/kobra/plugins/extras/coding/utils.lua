local M = {}

M[#M + 1] = {
	"m-demare/hlargs.nvim",
	event = "BufReadPre",
	config = true,
}

M[#M + 1] = {
	"f-person/git-blame.nvim",
	event = "BufReadPre",
}

M[#M + 1] = {
	"ruifm/gitlinker.nvim",
	keys = {
		{ "<leader>gy", '<cmd>lua require"gitlinker".get_repo_url()<cr>', mode = "n", desc = "Get Link" },
		{
			"<leader>gy",
			'<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
			mode = "v",
			desc = "Get Link",
		},
	},
	config = true,
}

return M
