local level = require("scripts.modules.data.level")
local const = require("scripts.modules.data.const")
local cfg = require("scripts.modules.data.cfg")

local M = {}

local function setup_slot(slot, center, size)
	local spacing = cfg.field_size / size
	local position = vmath.vector3(
		center.x - cfg.field_size / 2.0 + (slot.x - 1) * spacing + spacing / 2,
		center.y + cfg.field_size / 2.0 - (slot.y - 1) * spacing - spacing / 2,
		0
	)
	local cell_size = vmath.vector3(
		spacing * cfg.field_spacing_coeff,
		spacing * cfg.field_spacing_coeff,
		0
	)
	local text_scale = vmath.vector3(
		cell_size.x / cfg.text_scale_coeff,
		cell_size.x / cfg.text_scale_coeff,
		1
	)

	gui.set_color(slot.back_node, const.empty_color)
	gui.set_position(slot.back_node, position)
	gui.set_size(slot.back_node, cell_size)

	gui.set_text(slot.letter_node, slot.letter)
	gui.set_scale(slot.letter_node, text_scale)
end

function M.create(self)
	self.slots = {}
	local template_node = gui.get_node(const.field_letter_template)
	local center = gui.get_position(template_node)
	local size = level.current_level.size

	for y = 1, size do
		for x = 1, size do
			if y == 1 then
				self.slots[x] = {}
			end
			local index = (y - 1) * size + x
			local letter = utf8.upper(level.current_level.letters[index])
			local nodes = gui.clone_tree(template_node)
			self.slots[x][y] = {
				back_node = nodes[const.field_letter_template],
				letter_node = nodes[const.field_letter],
				letter = letter,
				index = index,
				x = x,
				y = y,
				is_finished = false
			}

			setup_slot(self.slots[x][y], center, size)
		end
	end
	gui.set_enabled(template_node, false)
end

return M