local M = {}

function M.clue_options(clues, triggers)
	return function(_, opts)
		if type(clues) == "function" then
			clues = clues()
		end

		if type(triggers) == "function" then
			triggers = triggers()
		end

		opts = opts or {}

		opts.triggers = opts.triggers or {}
		for _, trigger in ipairs(triggers or {}) do
			table.insert(opts.triggers, trigger)
		end

		opts.clues = opts.clues or {}
		for _, clue in ipairs(clues or {}) do
			table.insert(opts.clues, clue)
		end
	end
end

return M
