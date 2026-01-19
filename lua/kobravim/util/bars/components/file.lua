local bars = KobraVim.bars
local palette = bars.palette

return {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,

	hl = { bg = palette.blue },

	{ -- directory
		init = function(self)
			self.is_local = vim.fn.haslocaldir(0) == 1
			local cwd = vim.fn.getcwd(0)

			cwd = vim.fn.fnamemodify(cwd, ":~")
			if #cwd > vim.api.nvim_win_get_width(0) * 0.25 then
				cwd = vim.fn.pathshorten(cwd)
			end

			self.cwd = cwd
		end,
		provider = function(self)
			local icon = self.is_local and "󱂬 " or "󰉖 "
			local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return icon .. self.cwd .. trail
		end,
		hl = { italic = true },
	},

	{ -- filename
		provider = function(self)
			local name = vim.fn.fnamemodify(self.filename, ":t")
			return name == "" and "[No Name]" or name .. " "
		end,
		hl = { bold = true },
	},

	{ -- file icon
		init = function(self)
			local filename = vim.fn.fnamemodify(self.filename, ":t")
			local extension = vim.fn.fnamemodify(filename, ":e")
			self.icon, self.icon_color =
				require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
		end,
		provider = function(self)
			return self.icon and (self.icon .. " ")
		end,
	},

	-- status flags
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " ●",
	},

	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = " ",
	},

	{ provider = "%<" },
}
