local M = {}

local conf = require('kobra.config.colorscheme.config')

M[#M+1] = {
  'folke/tokyonight.nvim',
  lazy = true,
  opts = { style = 'moon' },
}

M[#M+1] = {
  'shaunsingh/moonlight.nvim',
  lazy = true,
  config = conf.moonlight,
}

M[#M+1] = {
  'EdenEast/nightfox.nvim',
  config = conf.nightfox,
  lazy = true,
}

return M
