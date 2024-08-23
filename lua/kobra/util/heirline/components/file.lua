local M = {}

local conditions = require("heirline.conditions")

function M.work_dir()
  return {
    provider = function()
      local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. Kobra.config.icons.kinds.Folder
      local cwd = vim.fn.getcwd(0)
      cwd = vim.fn.fnamemodify(cwd, ":~")
      
      if not conditions.width_percent_below(#cwd, 0.25) then
        cwd = vim.fn.pathshorten(cwd)
      end
      
      local trail = cwd:sub(-1) == "/" and " " or "/ "
      return icon .. cwd .. trail
    end,
    hl = "kobra_term_gray",
  }
end

function M.file_icon()
  return {
    init = function(self)
      if not self.filename then
        self.filename = vim.api.nvim_buf_get_name(0)
      end
      
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon_data = require("mini.icons").get("file", filename .. extension)
    end,
    provider = function(self)
      return " " .. self.icon_data.icon and (self.icon_data.icon .. " ")
    end,
    hl = "kobra_term_gray",
  }
end

function M.file_name()
  return {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        return "[No Name]"
      end
      
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      
      return filename
    end,
    hl = "kobra_term_gray",
  }
end

function M.file_flags()
  return {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = "[+]",
      hl = "kobra_term_green",
    },
    {
      condition = function()
        return vim.bo.readonly
      end,
      provider = "[RO]",
      hl = "kobra_term_red",
    },
  }
end

function M.component()
  return {
    {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    },
    M.work_dir(),
    M.file_icon(),
    M.file_name(),
    M.file_flags(),
    { provider = "%<" },
  }
end

return M
