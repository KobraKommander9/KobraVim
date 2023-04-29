local M = {}

-- this was taken from https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/master/lua/telescope/_extensions/file_browser/config.lua
M.hijack_netrw = function()
  local netrw_bufname

  pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' })
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function()
      pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' })
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('telescope-file-browser.nvim', { clear = true }),
    pattern = '*',
    callback = function()
      vim.schedule(function()
        if vim.bo[0].filetype == 'netrw' then
          return
        end

        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(bufname) == 0 then
          _, netrw_bufname = pcall(vim.fn.expand, '#:p:h')
          return
        end

        if netrw_bufname == bufname then
          netrw_bufname = nil
          return
        else
          netrw_bufname = bufname
        end

        vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')

        require('telescope').extensions.file_browser.file_browser {
          cwd = vim.fn.expand '%:p:h',
        }
      end)
    end,
    desc = 'telescope-file-browser.nvim replacement for netrw',
  })
end

return M
