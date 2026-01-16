local M = {}

function M.builtin(fn, opts)
	return "<cmd>lua require('mini.pick').builtin." .. fn .. "(" .. (opts or "") .. ")<cr>"
end

function M.extra(fn, opts)
	return "<cmd>lua require('mini.extra').pickers." .. fn .. "(" .. (opts or "") .. ")<cr>"
end

function M.hidden_files()
	return function()
		require("mini.pick").builtin.files({
			path_filter = function(name)
				-- always include normal (non-dot) files
				if not name:match("^%.") then
					return true
				end

				local exclude = {
					".git",
					".DS_Store",
					".gitmodules",
				}

				for _, ex in ipairs(exclude) do
					if name == ex then
						return false
					end
				end

				-- include all other dotfiles
				return true
			end,
		})
	end
end

return M
