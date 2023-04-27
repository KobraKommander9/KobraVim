local commands = {}

function commands.init()
  vim.api.nvim_create_user_command('CurrFile', require('kobra.core.scripts.files').copy_current_file_to_clipboard, {})
end

return commands
