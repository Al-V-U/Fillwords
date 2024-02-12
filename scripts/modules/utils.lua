local const = require("scripts.modules.data.const")

_G.original_print = print
print = function(...)
	_G.original_print(...)
--	_G.original_print(debug.traceback())
end

local M = {}

function M.calc_direction(dif_x, dif_y)
	local dir = const.DIRECTIONS.NONE
	if dif_x ~= 0 then
		dir = dif_x < 0 and const.DIRECTIONS.RIGHT or const.DIRECTIONS.LEFT
	elseif dif_y ~= 0 then
		dir = dif_y < 0 and const.DIRECTIONS.BOTTOM or const.DIRECTIONS.TOP
	end

	return dir
end

return M

