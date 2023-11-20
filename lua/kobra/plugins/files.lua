local M = {}

-- file utilities
local setupDotFileToggle = function()
	local show_dotfiles = true

	local filter_show = function(_)
		return true
	end

	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end

	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		MiniFiles.refresh({ content = { filter = new_filter } })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
		end,
	})
end

local setupSplitMappings = function()
	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			-- Make new window and set it as target
			local new_target_window
			vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
				vim.cmd(direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)

			MiniFiles.set_target_window(new_target_window)
		end

		-- adding 'desc' will result into 'show_help' entries
		local desc = "Split " .. direction
		vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			map_split(buf_id, "gs", "belowright horizontal")
			map_split(buf_id, "gv", "belowright vertical")
		end,
	})
end

local setupCwdMapping = function()
	local files_set_cwd = function(_)
		-- Works only if cursor is on the valid file system entry
		local cur_entry_path = MiniFiles.get_fs_entry().path
		local cur_directory = vim.fs.dirname(cur_entry_path)
		vim.fn.chdir(cur_directory)
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			vim.keymap.set("n", "g/", files_set_cwd, { buffer = args.data.buf_id })
		end,
	})
end

-- file browser
M[#M + 1] = {
	"echasnovski/mini.files",
	event = "VimEnter",
	keys = {
		{
			"<leader>ff",
			function()
				if not MiniFiles.close() then
					MiniFiles.open(vim.fn.expand("%:p:h"))
				end
			end,
			desc = "View Files",
		},
	},
	version = false,
	config = function(_, opts)
		local options = {}

		if require("kobra.core").layouts.colemak then
			options.mappings = {
				go_in = "i",
				go_in_plus = "I",
			}
		end

		options = vim.tbl_deep_extend("force", options, opts)
		require("mini.files").setup(options)

		setupDotFileToggle()
		setupSplitMappings()
		setupCwdMapping()
	end,
}

return M
