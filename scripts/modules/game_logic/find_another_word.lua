local game_play_data = require("scripts.modules.data.game_play_data")
local const = require("scripts.modules.data.const")
local cfg = require("scripts.modules.data.cfg")

local M = {}

function M.fly_word_to_counter()
	local link = game_play_data.link
	local move_pos = gui.get_position(gui.get_node("found_words_counter"))
	local index = 1
	local template_node = gui.get_node(const.N_FIELD_LETTER_BACK)
	gui.set_enabled(template_node, true)
	for _, slot in pairs(link) do
		local clone_slot = gui.clone_tree(template_node)
		local back_node = clone_slot[index][const.N_FIELD_LETTER_BACK]
		local text_node = clone_slot[index][const.N_FIELD_LETTER_TEXT]
		local connector_node = clone_slot[index][const.N_CONNECTOR]
		local position = gui.get_position(slot.back_node)

		gui.set_position(back_node, position)
		gui.set_color(back_node, slot.back_color)
		gui.set_text(text_node, slot.letter)
		gui.set_enabled(connector_node, false)
		gui.set_layer(back_node, "fly_anim")

		gui.animate(
			clone_slot[const.N_FIELD_LETTER_BACK],
			"position", move_pos, gui.EASING_OUTCUBIC, cfg.fly_move_time
		)
		gui.animate(
			clone_slot[const.N_FIELD_LETTER_BACK],
			"scale", const.VECTOR_3_ZERO, gui.EASING_OUTCUBIC,
			cfg.fly_scale_time, cfg.fly_scale_delay,
			function()
				gui.delete_node(back_node)
			end
		)
		index = index + 1
	end
	gui.set_enabled(template_node, false)
end

return M