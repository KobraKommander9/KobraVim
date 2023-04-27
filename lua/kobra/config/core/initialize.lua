local M = {}

M.treesitter_objects = function()
  local plugin = require('kobra.core.config').spec.splugins['nvim-treesitter']
  local opts = require('kobra.core.plugin').values(plugin, 'opts', false)
  local enabled = false
  if opts.textobjects then
    for _, mod in ipairs({ 'move', 'select', 'swap', 'lsp_interop' }) do
      if opts.textobjects[mod] and opts.textobjects[mod].enable then
        enabled = true
        break
      end
    end
  end
  if not enabled then
    require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
  end
end

return M
