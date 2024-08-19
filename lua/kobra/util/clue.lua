local M = {}

function M.options(clues, triggers)
	return function(_, opts)
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
