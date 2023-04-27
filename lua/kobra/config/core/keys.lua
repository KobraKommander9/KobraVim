local M = {}

M.treesitter = function()
  return {
    { '<c-space>', desc = 'Increment selection' },
    { '<bs>', desc = 'Descrement selection', mode = 'x' },
  }
end

return M
