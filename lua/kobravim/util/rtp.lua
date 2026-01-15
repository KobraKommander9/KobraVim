local M = {}

function M.add_current_dir(file_path)
	local current_dir = vim.fn.fnamemodify(file_path, ":p:h")

	local rtp = vim.opt.rtp:get()
	for _, path in ipairs(rtp) do
		if path == current_dir then
			return
		end
	end

	vim.opt.rtp:append(current_dir)
end

return M
