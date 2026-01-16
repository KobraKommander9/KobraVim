local M = {}

function M.copy_current_to_clipboard()
	local current_file = vim.fn.expand("%")
	vim.api.nvim_command('let @+="' .. current_file .. '"')
	vim.notify("Copied " .. current_file .. " to clipboard")
end

return M
