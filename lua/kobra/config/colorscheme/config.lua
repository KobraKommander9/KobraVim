local config = {}

config.moonlight = function()
  vim.g.moonlight_borders = true
  require('moonlight').set()
  vim.cmd.colorscheme('moonlight')
end

config.nightfox = function()
  vim.cmd.colorscheme('carbonfox')
end

return config
