local M = {}

M.startup_time = function()
  vim.g.startuptime_tries = 10
end

M.possession = function()
  require('possession').setup({})
end

return M
