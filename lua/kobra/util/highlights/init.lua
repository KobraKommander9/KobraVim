local M = {}

setmetatable(M, {
	__index = function(t, key)
		t[key] = require("kobra.util.highlights." .. key)
		return t[key]
	end,
})

-- function M.setup()
-- 	local theme = KobraColors.theme
-- 	KobraColors.hightlight.create_highlight_groups(theme)
--
-- 	local group = vim.api.nvim_create_augroup("KobraFormat", { clear = false })
-- 	vim.api.nvim_create_autocmd("ColorScheme", {
-- 		group = group,
-- 		pattern = "*",
-- 		callback = M.setup,
-- 	})
--
-- 	vim.api.nvim_create_autocmd("OptionSet", {
-- 		group = group,
-- 		pattern = "background",
-- 		callback = M.setup,
-- 	})
-- end

return M
