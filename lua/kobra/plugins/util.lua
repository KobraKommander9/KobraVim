local M = {}

local input = function(command)
  vim.ui.input({
    prompt = 'Enter name: ',
  }, function(val)
    if not val then
      return
    end

    vim.api.nvim_command(command .. ' ' .. val)
  end)
end

M[#M+1] = {
  'dstein64/vim-startuptime',
  cmd = 'StartupTime',
  config = function()
    vim.g.startuptime_tries = 10
  end,
}

M[#M+1] = {
  'jedrzejboczar/possession.nvim',
  event = 'BufReadPre',
  commands = {
    'PossessionSave',
    'PossessionLoad',
    'PossessionRename',
    'PossessionClose',
    'PossessionDelete',
    'PossessionShow',
    'PossessionList',
    'PossessionMigrate',
  },
  dependencies = {
    {
      'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      keys = {
        { '<leader>qs', '<cmd>Telescope possession list<cr>', desc = 'List Sessions' },
      },
      opts = function()
        if require('kobra.util').has('possession.nvim') then
          require('telescope').load_extension('possession')
        end
      end,
    },
  },
  keys = {
    { '<leader>qc', ':PossessionClose<cr>', desc = 'Close Session' },
    { '<leader>qd', function() input('PossessionDelete') end, desc = 'Delete Session' },
    { '<leader>qr', function() input('PossessionLoad') end, desc = 'Restore Session' },
    { '<leader>ql', ':PossessionLoad<cr>', desc = 'Restore Last Session' },
    { '<leader>qw', ':PossessionSave<cr>', desc = 'Save Current Session' },
    { '<leader>qW', function() input('PossessionSave') end, desc = 'Save Session' },
  },
}

M[#M+1] = { 'nvim-lua/plenary.nvim', lazy = true }

M[#M+1] = { 'tpope/vim-repeat', event = 'VeryLazy' }

return M
