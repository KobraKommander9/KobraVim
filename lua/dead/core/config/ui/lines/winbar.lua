local winbar = {}

winbar.winbar = function()
  local components = require('kobra.core.config.ui.lines.components')
  return vim.tbl_extend('force', components.parent(), components.winbar())
end

return winbar
