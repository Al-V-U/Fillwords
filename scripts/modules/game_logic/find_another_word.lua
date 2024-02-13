local game_play_data = require("scripts.modules.data.game_play_data")
local const = require("scripts.modules.data.const")
local cfg = require("scripts.modules.data.cfg")

local M = {}

local function calculate_center(link)
	local sum_x, sum_y = 0, 0
	local count = 0

	for _, slot in pairs(link) do
		local position = gui.get_position(slot.back_node)
		sum_x = sum_x + position.x
		sum_y = sum_y + position.y
		count = count + 1
	end

	local center_x = sum_x / count
	local center_y = sum_y / count

	return vmath.vector3(center_x, center_y, 0)
end

function M.fly_word_to_counter()
	local link = game_play_data.link

	local center = calculate_center(link)
	local anim_node = gui.new_box_node(center, const.VECTOR_3_ZERO)
	local field_node = gui.get_node("field")
	local field_pos = gui.get_position(field_node)

	gui.set_parent(anim_node, field_node)
	gui.set_position(anim_node, center)
	gui.set_layer(anim_node, "fly_anim")

	local move_pos = gui.get_position(gui.get_node("found_words_counter"))
	local template_node = gui.get_node(const.N_FIELD_LETTER_BACK)
	gui.set_enabled(template_node, true)
	for _, slot in pairs(link) do
		local clone_slot = gui.clone_tree(template_node)
		local back_node = clone_slot[const.N_FIELD_LETTER_BACK]
		local text_node = clone_slot[const.N_FIELD_LETTER_TEXT]
		local connector_node = clone_slot[const.N_CONNECTOR]
		local position = gui.get_position(slot.back_node)

		gui.set_parent(back_node, anim_node)
		gui.set_position(back_node, position - center)
		gui.set_color(back_node, slot.back_color)
		gui.set_text(text_node, slot.letter)
		gui.set_size(back_node, cfg.cell_size)
		gui.set_scale(text_node, cfg.letter_normal_scale)
		gui.set_enabled(connector_node, false)
		gui.set_layer(back_node, "fly_anim")
	end
	gui.animate(
		anim_node,
		"position", move_pos - field_pos, gui.EASING_OUTCUBIC, cfg.fly_move_time
	)
	gui.animate(
		anim_node,
		"scale", cfg.fly_scale, gui.EASING_OUTCUBIC,
		cfg.fly_scale_time
	)
	gui.animate(
		anim_node,
		"color", vmath.vector4(1, 1, 1, 0), gui.EASING_LINEAR,
		cfg.fly_scale_time, cfg.fly_scale_time - 0.1,
		function()
			gui.delete_node(anim_node)
		end
	)

	gui.set_enabled(template_node, false)
end

return M