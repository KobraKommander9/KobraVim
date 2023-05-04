local M = {}

M[#M+1] = {
  'm-demare/hlargs.nvim',
  event = 'BufReadPre',
}

M[#M+1] = {
  'f-persion/git-blame.nvim',
  event = 'BufReadPre',
}

M[#M+1] = {
  'ruifm/gitlinker.nvim',
  keys = {
    { '<leader>gy', '<cmd>lua require"gitlinker".get_repo_url()<cr>', mode = 'n', desc = 'Get Link' },
    { '<leader>gy', '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>', mode = 'v', desc = 'Get Link' },
  },
}

return M
