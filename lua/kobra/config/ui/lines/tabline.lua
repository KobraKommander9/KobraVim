local tabline = {}

tabline.tabline = function()
  local components = require('kobra.config.ui.lines.components')
  return vim.tbl_extend('force', components.parent(), components.tabline())
end

return tabline
