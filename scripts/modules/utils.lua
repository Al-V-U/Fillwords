local const = require("scripts.modules.data.const")

_G.original_print = print
print = function(...)
	_G.original_print(...)
--	_G.original_print(debug.traceback())
end

local M = {}

function M.calc_direction(dif_x, dif_y)
	local dir = const.directions.none
	if dif_x ~= 0 then
		dir = dif_x < 0 and const.directions.right or const.directions.left
	elseif dif_y ~= 0 then
		dir = dif_y < 0 and const.directions.bottom or const.directions.top
	end

	return dir
end

return M

