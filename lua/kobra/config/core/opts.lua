local M = {}

M.which_key = function(_, opts)
  if require('kobra.util').has('noice.nvim') then
    opts.defaults['<leader>sn'] = { name = '+noice' }
  end
end

M.treesitter = function(_, opts)
  if type(opts.ensure_installed) == 'table' then
    local added = {}
    opts.ensure_installed = vim.tbl_filter(function(lang)
      if added[lang] then
        return false
      end
      added[lang] = true
      return true
    end, opts.ensure_installed)
  end
  require('nvimn-treesitter.configs').setup(opts)
end

return M
