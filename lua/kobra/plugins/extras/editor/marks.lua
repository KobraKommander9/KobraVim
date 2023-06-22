local M = {}

M[#M + 1] = {
	"LeonHeidelbach/trailblazer.nvim",
	cmd = {
		"TrailBlazerOpenTrailMarkList",
		"TrailBlazerSaveSession",
		"TrailBlazerLoadSession",
		"TrailBlazerDeleteSession",
	},
	keys = function()
		local keys = { j = "j", k = "k" }

		if require("kobra.core").layouts.colemak then
			keys = { j = "n", k = "e" }
		end

		return {
			{ "mx", mode = { "n", "v" }, desc = "New Trail Mark" },
			{ "mb", mode = { "n", "v" }, desc = "Track Back" },
			{ "m" .. keys.j, mode = { "n", "v" }, desc = "Peek Next Down" },
			{ "m" .. keys.k, mode = { "n", "v" }, desc = "Peek Previous Up" },
			{ "mm", mode = { "n", "v" }, desc = "Move To Nearest" },
			{ "mt", mode = { "n", "v" }, desc = "Toggle Trail Marks" },
			{ "mD", mode = { "n", "v" }, desc = "Delete All Trail Marks" },
			{ "mp", mode = { "n", "v" }, desc = "Paste at Last Trail Mark" },
			{ "mP", mode = { "n", "v" }, desc = "Paste at All Trail Marks" },
			{ "ms", mode = { "n", "v" }, desc = "Set Trail Mark Select Mode" },
			{ "m.", mode = { "n", "v" }, desc = "Switch to Next Trail Mark Stack" },
			{ "m,", mode = { "n", "v" }, desc = "Switch to Previous Trail Mark Stack" },
			{ "mS", mode = { "n", "v" }, desc = "Set Trail Mark Stack Sort Mode" },
			{ "ml", "<cmd>TrailBlazerOpenTrailMarkList<cr>", desc = "Open Trail Mark List" },
		}
	end,
	config = function(_, opts)
		local keys = {
			j = "j",
			k = "k",
		}

		if require("kobra.core").layouts.colemak then
			keys = {
				j = "n",
				k = "e",
			}
		end

		local options = {
			trail_mark_in_text_highlights_enabled = false,
			trail_mark_symbol_line_indicators_enabled = true,
			mark_symbol = require("kobra.core").icons.marks.Flag,
			newest_mark_symbol = require("kobra.core").icons.marks.Newest,
			cursor_mark_symbol = require("kobra.core").icons.marks.Cursor,
			next_mark_symbol = require("kobra.core").icons.marks.Next,
			previous_mark_symbol = require("kobra.core").icons.marks.Previous,
			mappings = {
				nv = {
					motions = {
						new_trail_mark = "mx",
						track_back = "mb",
						peek_move_next_down = "m" .. keys.j,
						peek_move_previous_up = "m" .. keys.k,
						move_to_nearest = "mm",
						toggle_trail_mark_list = "mt",
					},
					actions = {
						delete_all_trail_marks = "mD",
						paste_at_last_trail_mark = "mp",
						paste_at_all_trail_marks = "mP",
						set_trail_mark_select_mode = "ms",
						switch_to_next_trail_mark_stack = "m.",
						switch_to_previous_trail_mark_stack = "m,",
						set_trail_mark_stack_sort_mode = "mS",
					},
				},
			},
			quickfix_mappings = {
				v = {
					actions = {
						qf_action_move_selected_trail_marks_down = "<C-" .. keys.j .. ">",
						qf_action_move_selected_trail_marks_up = "<C-" .. keys.k .. ">",
					},
				},
			},
		}

		options = vim.tbl_deep_extend("force", options, opts)
		require("trailblazer").setup(options)
	end,
}

M[#M + 1] = {
	"folke/which-key.nvim",
	opts = {
		defaults = {
			["m"] = { name = "+marks" },
		},
	},
}

return M
