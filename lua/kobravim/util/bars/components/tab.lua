return {
	init = function(self)
		local buflist = vim.fn.tabpagebuflist(self.tabnr)
		local winid = vim.fn.tabpagewinnr(self.tabnr)
		local bufnr = buflist[winid]

		self.name = vim.fn.bufname(bufnr)
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo[bufnr].filetype, { default = true })
	end,

	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
	end,

	{
		provider = function(self)
			return self.icon and (self.icon .. " ")
		end,
	},

	{
		provider = function(self)
			return self.name == "" and "[No Name]" or vim.fn.fnamemodify(self.name, ":t") .. " "
		end,
	},
}
