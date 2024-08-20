vim.api.nvim_create_user_command(
	"CurrFile",
	KobraScripts.files.copy_current_to_clipboard,
	{ desc = "Copy current file path to clipboard" }
)

vim.api.nvim_create_user_command("KobraHealth", function()
	vim.cmd([[Lazy! load all]])
	vim.cmd([[checkhealth]])
end, { desc = "Load all plugins and run :checkhealth" })
