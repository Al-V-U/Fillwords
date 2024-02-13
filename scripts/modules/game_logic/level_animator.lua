local cfg = require("scripts.modules.data.cfg")
local const = require("scripts.modules.data.const")
local game_play_data = require("scripts.modules.data.game_play_data")
local level = require("scripts.modules.data.level")

local M = {}

function M.start_level_animate(callback)
	for _, s in pairs(game_play_data.slots) do
		for _, slot in pairs(s) do
			gui.animate(
				slot.back_node, "scale",
				const.VECTOR_3_ONE, gui.EASING_OUTCUBIC,
				cfg.show_level_time, 0, callback
			)
			callback = nil
		end
	end
end

function M.finish_level_animate(callback)
	local index = 1
	for y = 1, level.current_level.size do
		for x = 1, level.current_level.size do
			local slot = game_play_data.slots[x][y]
			gui.animate(
				slot.letter_node, "scale",
				vmath.vector3(cfg.letter_normal_scale.x * cfg.win_anim_letter_scale,
					cfg.letter_normal_scale.y * cfg.win_anim_letter_scale, 1),
				gui.EASING_LINEAR, cfg.win_anim_scale_up_time,
				cfg.win_anim_letter_delay * index,
				function()
					gui.animate(
						slot.letter_node, "scale",
						vmath.vector3(cfg.letter_normal_scale.x,
							cfg.letter_normal_scale.y, 1),
						gui.EASING_LINEAR, cfg.win_anim_scale_down_time
					)
				end
			)
			index = index + 1
		end
	end
	timer.delay(cfg.win_anim_letter_delay * index, false, callback)
end

return M