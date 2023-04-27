local M = {}

M[#M+1] = {
  'folke/tokyonight.nvim',
  lazy = true,
  opts = { style = 'moon' },
}

M[#M+1] = {
  'shaunsingh/moonlight.nvim',
  lazy = true,
  init = function()
    vim.g.moonlight_borders = true
  end
}

M[#M+1] = {
  'EdenEast/nightfox.nvim',
  lazy = true,
}

return M
