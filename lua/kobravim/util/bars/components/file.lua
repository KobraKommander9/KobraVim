local bars = KobraVim.bars
local palette = bars.palette

return {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,

	hl = { bg = palette.blue },

	-- status flags
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "● ",
	},

	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = " ",
	},

	{ -- directory
		provider = function(self)
			local path = vim.fn.fnamemodify(self.filename, ":.")
			if path == "" then
				return ""
			end

			local dir = vim.fn.fnamemodify(path, ":h")
			if dir == "." then
				return ""
			end

			return " " .. dir .. "/"
		end,
		hl = { italic = true, alpha = 0.8 },
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

	{ provider = "%<" },
}
