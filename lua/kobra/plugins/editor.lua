local M = {}

-- global search and replace
M[#M+1] = {
  'nvim-pack/nvim-spectre',
  keys = {
    { '<leader>sr', function() require('spectre').open() end, desc = 'Replace in files (Spectre)' },
  },
}

-- file browser
M[#M+1] = {
  'telescope.nvim',
  dependencies = {
    {
      'nvim-telescope/telescope-file-browser.nvim',
      event = 'VeryLazy',
      config = function()
        require('telescope').load_extension('file_browser')
      end,
      keys = {
        { '<leader>ff', '<cmd>Telescope file_browser path=%:p:h hidden=true<cr>', 'Find Browser' },
      },
    },
  },
  opts = function(_, opts)
    opts.extensions.file_browser = {
      hijack_netrw = true,
      grouped = true,
      display_stat = false,
      hidden = true,
    }

    if require('kobra.core').layouts.colemak then
      local actions = require('telescope').extensions.file_browser.actions
      opts.extensions.file_browser.mappings = {
        i = {
          ['<C-a>'] = actions.create,
          ['<C-r>'] = actions.rename,
          ['<C-y>'] = actions.copy,
          ['<C-x>'] = actions.remove,
          ['<C-h>'] = actions.toggle_hidden,
        },
      }
    end

    return opts
  end,
}

-- fuzzy finder
M[#M+1] = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  version = false,
  keys = {

  },
}

return M
