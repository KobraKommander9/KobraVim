local M = {}

local utils = require("heirline.utils")

function M.enclose(delimiters, color1, color2, component)
	component = utils.clone(component)

	local surround_color1 = function(self)
		if type(color1) == "function" then
			return color1(self)
		else
			return color1
		end
	end

	local surround_color2 = function(self)
		if type(color2) == "function" then
			return color2(self)
		else
			return color2
		end
	end

	return {
		{
			provider = delimiters[1],
			hl = function(self)
				local s_color = surround_color1(self)
				if s_color then
					return s_color
				end
			end,
		},
		component,
		{
			provider = delimiters[2],
			hl = function(self)
				local s_color = surround_color2(self)
				if s_color then
					return s_color
				end
			end,
		},
	}
end

function M.surround(delimiters, color, component)
	return M.enclose(delimiters, color, color, component)
end

return M
