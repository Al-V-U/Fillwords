local cfg = require("scripts.modules.data.cfg")
local const = require("scripts.modules.data.const")

local M = {}

local back_node = nil
local text_node = nil
local font = nil
local back_color = vmath.vector4(1, 1, 1, 1)
local back_height = 100
local back_size_offset = 60

local function set_alpha(alpha)
	cfg.entered_words_text_color.w = alpha
	back_color.w = alpha
	gui.set_color(back_node, back_color)
	gui.set_color(text_node, cfg.entered_words_text_color)
end

local function animate_alpha(alpha)
	cfg.entered_words_text_color.w = alpha
	back_color.w = alpha
	gui.animate(back_node, "color", back_color, gui.EASING_LINEAR, 0.3)
	gui.animate(text_node, "color", cfg.entered_words_text_color, gui.EASING_LINEAR, 0.3)
end

function M.init()
	back_node = gui.get_node(const.N_ENTERED_WORD)
	text_node = gui.get_node(const.N_ENTERED_WORD_TEXT)
	local font_name = gui.get_font(text_node)
	font = gui.get_font_resource(font_name)
	set_alpha(0)
end

function M.set_word(link, color)
	if link == nil or #link == 0 then
		animate_alpha(0)
	else
		back_color = vmath.vector4(color)
		local word = ""
		for _, slot in pairs(link) do
			word = word .. slot.letter
		end
		gui.set_text(text_node, word)

		local metrics = resource.get_text_metrics(font, word)
		gui.set_size(back_node, vmath.vector3(metrics.width + back_size_offset, back_height, 0))

		animate_alpha(1)
	end
end

return M