local M = {}

M[#M+1] = {
  'rcarriga/nvim-notify',
  keys = {
    {
      '<leader>un',
      function()
        require('notify').dismiss({ silent = true, pending = true })
      end,
      desc = 'Dismiss all Notifications',
    },
  },
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
  init = function()
    -- when noice is not enabled, install notify on VeryLazy
    local util = require('kobra.util')
    if not util.has('noice.nvim') then
      util.on_very_lazy(function()
        vim.notify = require('notify')
      end)
    end
  end,
}

M[#M+1] = {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.input(...)
    end
  end,
}

M[#M+1] = {
  'nanozuki/tabby.nvim',
  event = 'VeryLazy',
  config = require('kobra.config.ui.tabline').setup,
}

M[#M+1] = {
  'rebelot/heirline.nvim',
  event = 'VeryLazy',
  config = function()
    require('heirline').setup({
      statusline = require('kobra.config.ui.lines.statusline').statusline(),
      winbar = require('kobra.config.ui.lines.winbar').winbar(),
      -- tabline = require('kobra.config.ui.lines.tabline').tabline(),
    })
  end,
}

M[#M+1] = {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- which key integration
    {
      'folke/which-key.nvim',
      opts = function(_, opts)
        if require('kobra.util').has('noice.nvim') then
          opts.defaults['<leader>sn'] = { name = '+noice' }
        end
      end,
    },
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  keys = {
    { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
    { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
    { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
    { '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
    { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
    { '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
    { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
    {
      '<leader>sn',
      function()
        require('telescope').load_extension('notify')
        require('telescope').extensions.notify()
      end,
      'Notify Messages',
    },
  },
}

M[#M+1] = {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'jedrzejboczar/possession.nvim' },
  opts = require('kobra.config.ui.start-screen').setup,
  config = function(_, startify)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    require('alpha').setup(startify.config)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        startify.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}

M[#M+1] = {
  'SmiteshP/nvim-navic',
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    require('kobra.util').on_attach(function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, buffer)
      end
    end)
  end,
  opts = function()
    return {
      separator = ' ',
      highlight = true,
      depth_limit = 5,
      icons = require('kobra.core').icons.kinds,
    }
  end,
}

M[#M+1] = { 'nvim-tree/nvim-web-devicons', lazy = true }

M[#M+1] = { 'MunifTanjim/nui.nvim', lazy = true }

return M
