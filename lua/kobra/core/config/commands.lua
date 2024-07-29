vim.api.nvim_create_user_command("CurrFile", require("kobra.util.scripts.files").copy_current_file_to_clipboard, {})
