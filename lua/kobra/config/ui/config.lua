local config = {}

function config.heirline()
  require('heirline').setup({
    statusline = require('kobra.plugins.config.ui.lines.statusline').statusline(),
    winbar = require('kobra.plugins.config.ui.lines.winbar').winbar(),
    -- tabline = require('kobra.plugins.config.ui.lines.tabline').tabline(),
  })
end

function config.tabby()
  require('kobra.plugins.config.ui.lines.tabby').setup()
end

function config.alpha(_, dashboard)
  -- close lazy and re-open when the dashboard is ready
  if vim.o.filetype == 'lazy' then
    vim.cmd.close()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        require('lazy').show()
      end
    })
  end

  require('alpha').setup(dashboard.opts)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'KobraVimStarted',
    callback = function()
      local stats = require('lazy').stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return config
