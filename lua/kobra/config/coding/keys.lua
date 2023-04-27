local M = {}

M.luasnip = function()
  return {
    {
      '<tab>',
      function()
        return require('luasnip').jumpable(1)
          and '<Plug>luasnip-jump-next' or '<tab>'
      end,
      expr = true, silent = true, mode = 'i',
    },
    { '<tab>', function() require('luasnip').jump(1) end, mode = 's' },
    { '<s-tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
  }
end

M.mini_surround = function(_, keys)
  local plugin = require('lazy.core.config').spec.plugins['mini.surround']
  local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
  local mappings = {
    { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'v' } },
    { opts.mappings.delete, desc = 'Delete surrounding' },
    { opts.mappings.find, desc = 'Find right surrounding' },
    { opts.mappings.find_left, desc = 'Find left surrounding' },
    { opts.mappings.highlight, desc = 'Highlight surrounding' },
    { opts.mappings.replace, desc = 'Replace surrounding' },
    { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
  }
  mappings = vim.tbl_filter(function(m)
    return m[1] and #m[1] > 0
  end, mappings)
  return vim.list_extend(mappings, keys)
end

return M
