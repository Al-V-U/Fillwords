local level = require("scripts.modules.data.level")
local const = require("scripts.modules.data.const")
local cfg = require("scripts.modules.data.cfg")
local game_play_data = require("scripts.modules.data.game_play_data")

local M = {}

local function calc_slot_param(size)
	local field_size = cfg.is_portrait and cfg.field_size_portrait or cfg.field_size_landscape
	print("field_size", field_size)
	local spacing = field_size / size

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
	return spacing, cell_size, field_size
end

local function setup_connector(slot, direction, color)
	if direction == const.DIRECTIONS.NONE then
		gui.set_enabled(slot.connector_center_node, false)
		return
	end
	gui.set_enabled(slot.connector_center_node, true)
	gui.set_color(slot.connector_node, color)
	gui.set_rotation(slot.connector_center_node, vmath.quat_rotation_z(math.rad(direction)))
end

local function setup_slot(slot, center, spacing, cell_size, field_size, scale_to_zero)
	local position = vmath.vector3(
		center.x - field_size / 2.0 + (slot.x - 1) * spacing + spacing / 2,
		center.y + field_size / 2.0 - (slot.y - 1) * spacing - spacing / 2,
		0
	)

	gui.set_color(slot.back_node, slot.back_color)
	gui.set_position(slot.back_node, position)
	gui.set_size(slot.back_node, cell_size)

	gui.set_text(slot.letter_node, slot.letter)
	gui.set_scale(slot.letter_node, cfg.letter_normal_scale)

	gui.set_position(slot.connector_node, vmath.vector3(cell_size.x / 2, 0, 0))
	gui.set_size(slot.connector_node, vmath.vector3((spacing - cell_size.x) * 2, cell_size.y, 0))

	setup_connector(slot, slot.connector_direction, slot.back_color)

	if scale_to_zero then
		gui.set_scale(slot.back_node, const.VECTOR_3_ZERO)
	end
end

function M.setup_slots(scale_to_zero)
	scale_to_zero = scale_to_zero == nil and false or scale_to_zero
	local template_node = gui.get_node(const.N_FIELD_LETTER_BACK)
	local center = gui.get_position(template_node)
	local size = level.current_level.size
	local spacing, cell_size, field_size = calc_slot_param(size)

	for _, s in pairs(game_play_data.slots) do
		for _, slot in pairs(s) do
			setup_slot(slot, center, spacing, cell_size, field_size, scale_to_zero)
		end
	end
	gui.set_enabled(template_node, false)
end

function M.create(self)
	game_play_data.clear()
	local template_node = gui.get_node(const.N_FIELD_LETTER_BACK)
	local size = level.current_level.size

	for y = 1, size do
		for x = 1, size do
			if y == 1 then
				game_play_data.slots[x] = {}
			end
			local index = (y - 1) * size + x
			local letter = utf8.upper(level.current_level.letters[index])
			local nodes = gui.clone_tree(template_node)
			game_play_data.slots[x][y] = {
				back_node = nodes[const.N_FIELD_LETTER_BACK],
				letter_node = nodes[const.N_FIELD_LETTER_TEXT],
				connector_center_node = nodes[const.N_CONNECTOR_CENTER],
				connector_node = nodes[const.N_CONNECTOR],
				connector_direction = const.DIRECTIONS.NONE,
				letter = letter,
				index = index,
				x = x,
				y = y,
				back_color = const.EMPTY_COLOR,
				is_finished = false
			}
		end
	end
	M.setup_slots(true)
end

return M