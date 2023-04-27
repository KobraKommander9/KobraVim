local M = {}

M.notify = function()
  return {
    {
      '<leader>un',
      function()
        require('notify').dismiss({ silent = true, pending = true })
      end,
      desc = 'Dismiss all notifications',
    },
  }
end

M.tabby = function()
  return {
    '<leader>al',
    '<leader>af',
    '<leader>aa',
    '<leader>an',
    '<leader>ac',
    '<leader>ap',
  }
end

M.noice = function()
  return {
    { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
    { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
    { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
    { '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
    { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
    { '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
    { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
  }
end

return M
