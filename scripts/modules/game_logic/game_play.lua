local const = require("scripts.modules.data.const")
local level = require("scripts.modules.data.level")
local words = require("scripts.modules.data.words")
local profile_service = require("scripts.modules.profile_service")

local M = {}

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

local function remove_link(self)
	if self.link == nil or #self.link == 0 then
		return false
	end

	local find, word = check_task_words(self.link)
	if not find then
		local another_word = words.check_word(self.link)
		if another_word ~= nil then
			print("find word:", another_word)
		end
	end
	if find then
		for _, slot in pairs(self.link) do
			slot.is_finished = true
		end
		profile_service.insert_word(word)
		return true
	end
	for _,slot in pairs(self.link) do
		gui.set_color(slot.back_node, const.empty_color)
	end
	return false
end

local function add_to_link(self, slot)
	-- outside board or empty
	if slot.is_finished then
		return false
	end

	local color = const.colors[profile_service.get_color_index()]

	-- add the first slot to the link without any checks
	if #self.link == 0 then
		--msg.post(slot.id_root, "zoom_in", {color =  const.colors[profile_service.get_color_index()], fast = fast})
		table.insert(self.link, slot)
		gui.set_color(slot.back_node, color)
		return true
	end

	local last = self.link[#self.link]
	local previous = self.link[#self.link - 1]
	local dist = math.abs(last.x - slot.x) + math.abs(last.y - slot.y)
	-- don't add the same slot more than once and don't add slots that are too far away
	if dist ~= 1 then
		return false
	end
	-- going back to the previous link
	-- remove the last slot of the link
	if previous == slot then
		self.link[#self.link] = nil
		gui.set_color(last.back_node, const.empty_color)
		return true
	end
	-- don't try to add the same slot twice
	for i=1,#self.link do
		if self.link[i] == slot then
			return false
		end
	end

	table.insert(self.link, slot)
	gui.set_color(slot.back_node, color)
	return true
end

local function check_input_node(self, x, y)
	for _, s in pairs(self.slots) do
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
	self.link = {}
end

function M.input(self, action_id, action)
	if action.pressed or (action_id == hash("touch") and self.linking) then
		local slot = check_input_node(self, action.x, action.y)
		if action.released then
			if remove_link(self) then
				check_win(self)
			end
			self.linking = false
			self.link = {}
		elseif slot ~= nil then
			if add_to_link(self, slot) then
				self.linking = true
			end
		end
	end
end

return M