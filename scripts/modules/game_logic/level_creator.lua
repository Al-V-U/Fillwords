local level = require("scripts.modules.data.level")
local const = require("scripts.modules.data.const")
local cfg = require("scripts.modules.data.cfg")
local game_play_data = require("scripts.modules.data.game_play_data")

local M = {}

local function calc_slot_param(size)
	local spacing = cfg.field_size / size

	local cell_size = vmath.vector3(
		spacing * cfg.field_spacing_coeff,
		spacing * cfg.field_spacing_coeff,
		0
	)
	cfg.letter_normal_scale = vmath.vector3(
		cell_size.x / cfg.text_scale_coeff,
		cell_size.x / cfg.text_scale_coeff,
		1
	)
	cfg.letter_select_scale = vmath.vector3(
		cfg.letter_normal_scale.x * cfg.letter_select_scale_coeff,
		cfg.letter_normal_scale.y * cfg.letter_select_scale_coeff,
		1
	)
	return spacing, cell_size
end

local function setup_slot(slot, center, spacing, cell_size)
	local position = vmath.vector3(
		center.x - cfg.field_size / 2.0 + (slot.x - 1) * spacing + spacing / 2,
		center.y + cfg.field_size / 2.0 - (slot.y - 1) * spacing - spacing / 2,
		0
	)

	gui.set_color(slot.back_node, const.empty_color)
	gui.set_position(slot.back_node, position)
	gui.set_size(slot.back_node, cell_size)

	gui.set_text(slot.letter_node, slot.letter)
	gui.set_scale(slot.letter_node, cfg.letter_normal_scale)

	gui.set_position(slot.connector_node, vmath.vector3(cell_size.x / 2, 0, 0))
	gui.set_size(slot.connector_node, vmath.vector3((spacing - cell_size.x) * 2, cell_size.y, 0))
	gui.set_enabled(slot.connector_center_node, false)

	gui.set_scale(slot.back_node, const.vector3_zero)
end

function M.create()
	game_play_data.clear()

	local template_node = gui.get_node(const.field_letter_template)
	local center = gui.get_position(template_node)
	local size = level.current_level.size

	local spacing, cell_size = calc_slot_param(size)

	for y = 1, size do
		for x = 1, size do
			if y == 1 then
				game_play_data.slots[x] = {}
			end
			local index = (y - 1) * size + x
			local letter = utf8.upper(level.current_level.letters[index])
			local nodes = gui.clone_tree(template_node)
			game_play_data.slots[x][y] = {
				back_node = nodes[const.field_letter_template],
				letter_node = nodes[const.field_letter],
				connector_center_node = nodes[const.connector_center],
				connector_node = nodes[const.connector],
				letter = letter,
				index = index,
				x = x,
				y = y,
				is_finished = false
			}

			setup_slot(game_play_data.slots[x][y], center, spacing, cell_size)
		end
	end
	gui.set_enabled(template_node, false)
end

return M