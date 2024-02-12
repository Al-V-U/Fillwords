local cfg = require("scripts.modules.data.cfg")
local const = require("scripts.modules.data.const")
local game_play_data = require("scripts.modules.data.game_play_data")

local M = {}

function M.animate(callback)
	for _, s in pairs(game_play_data.slots) do
		for _, slot in pairs(s) do
			gui.animate(slot.back_node, "scale",
				const.vector3_one, gui.EASING_OUTCUBIC,
				cfg.show_level_time, 0, callback
			)
			callback = nil
		end
	end
end

return M