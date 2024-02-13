local cfg = require("scripts.modules.data.cfg")
local const = require("scripts.modules.data.const")
local level = require("scripts.modules.data.level")
local words = require("scripts.modules.data.words")
local utils = require("scripts.modules.utils")
local entered_word = require("scripts.modules.game_logic.entered_word")
local profile_service = require("scripts.modules.profile_service")
local game_play_data = require("scripts.modules.data.game_play_data")
local find_another_word = require("scripts.modules.game_logic.find_another_word")

local M = {}

local function animate_letter(slot, zoom_in)
	local scale = zoom_in and cfg.letter_select_scale or cfg.letter_normal_scale
	gui.animate(slot.letter_node, "scale", scale, gui.EASING_OUTCUBIC, 0.2)
end

local function setup_connector(slot, direction, color)
	slot.connector_direction = direction
	if direction == const.DIRECTIONS.NONE then
		gui.set_enabled(slot.connector_center_node, false)
		return
	end
	gui.set_enabled(slot.connector_center_node, true)
	gui.set_color(slot.connector_node, color)
	gui.set_rotation(slot.connector_center_node, vmath.quat_rotation_z(math.rad(direction)))
end

local function check_task_words(link)
	local word
	for w, indexes in pairs(level.current_level.words) do
		word = w
		if #indexes == #link then
			local i = 1
			local find_this = true
			for _, slot in pairs(link) do
				if indexes[i] ~= slot.index then
					find_this = false
					break
				end
				i = i + 1
			end
			if find_this then
				return true, word
			end
		end
	end

	return false
end

local function setup_slot(slot, zoom_in, color, insert, connector_slot, direction)
	animate_letter(slot, zoom_in)
	gui.set_color(slot.back_node, color)
	slot.back_color = color
	setup_connector(connector_slot, direction, color)
	if insert then
		table.insert(game_play_data.link, slot)
	end
end

function M.remove_link(save)
	if game_play_data.link == nil or #game_play_data.link == 0 then
		return false
	end

	local find, word = check_task_words(game_play_data.link)
	if not find then
		local another_word = words.check_word(game_play_data.link)
		if another_word ~= nil then
			if level.current_level.words[another_word] ~= nil then
				--TODO: show info panel - right word in wrong place
				print("\"" .. utf8.upper(another_word) .. "\" - это правильное слово, но расположите его по другому")
			elseif profile_service.add_found_word(another_word) then
				find_another_word.fly_word_to_counter()
			else
				--TODO: show info panel - already found
				print("Слово: \"" .. utf8.upper(another_word) .. "\" уже угадано")
			end
		end
	end
	if find then
		for _, slot in pairs(game_play_data.link) do
			animate_letter(slot, false)
			slot.is_finished = true
		end
		profile_service.insert_word(word, save)
		return true
	end
	for _,slot in pairs(game_play_data.link) do
		setup_slot(slot, false, const.EMPTY_COLOR, false, slot, const.DIRECTIONS.NONE)
	end
	return false
end

function M.add_to_link(slot)
	-- ignore finished
	if slot.is_finished then
		return false
	end

	local color = const.COLORS[profile_service.get_color_index()]

	-- add the first slot to the link without any checks
	if #game_play_data.link == 0 then
		setup_slot(slot, true, color, true, slot, const.DIRECTIONS.NONE)
		return true, color
	end

	local last = game_play_data.link[#game_play_data.link]
	local previous = game_play_data.link[#game_play_data.link - 1]
	local dist = math.abs(last.x - slot.x) + math.abs(last.y - slot.y)
	-- don't add the same slot more than once and don't add slots that are too far away
	if dist ~= 1 then
		return false
	end
	-- going back to the previous link
	-- remove the last slot of the link
	if previous == slot then
		game_play_data.link[#game_play_data.link] = nil
		setup_slot(last, false, const.EMPTY_COLOR, false, slot, const.DIRECTIONS.NONE)
		return true, color
	end
	-- don't try to add the same slot twice
	for i=1,#game_play_data.link do
		if game_play_data.link[i] == slot then
			return false
		end
	end

	local direction = utils.calc_direction(last.x - slot.x, last.y - slot.y)
	setup_slot(slot, true, color, true, last, direction)
	return true, color
end

local function check_input_node(self, x, y)
	for _, s in pairs(game_play_data.slots) do
		for _, slot in pairs(s) do
			if gui.pick_node(slot.back_node, x, y) then
				return slot
			end
		end
	end
	return nil
end

local function check_win(self)
	if profile_service.get_inserted_words_count() == level.get_words_count() then
		self.level_complete_callback()
	end
end

function M.start_play(self, callback)
	self.level_complete_callback = callback
end

function M.input(self, action_id, action)
	if action.pressed or (action_id == hash("touch") and self.linking) then
		local slot = check_input_node(self, action.x, action.y)
		if action.released then
			if M.remove_link(true) then
				check_win(self)
			end
			self.linking = false
			game_play_data.link = {}
			entered_word.set_word(game_play_data.link)
		elseif slot ~= nil then
			local success, color = M.add_to_link(slot)
			if success then
				self.linking = true
				entered_word.set_word(game_play_data.link, color)
			end
		end
	end
end

return M