local profile = require("scripts.modules.profile")
local events = require 'scripts.modules.events'
local yagames = require("yagames.yagames")
local const = require("scripts.modules.const")

local M = {}

local initialized = false
local level_num = 1
local inserted_word_colors = {}

function M.init()
	yagames.player_init({ scopes = false }, function(self, err)
		if not err then
			initialized = true
			yagames.player_get_data(nil, function(self, err, data)
				print("yagames.player_get_data:", err or pprint(data))
				if data.found_words_counter ~= nil then
					profile.found_words_counter = data.found_words_counter
				end
				if data.last_finished_level_num ~= nil then
					profile.last_finished_level_num = data.last_finished_level_num
					level_num = profile.last_finished_level_num + 1
				end
				if data.inserted_words ~= nil then
					profile.inserted_words = data.inserted_words
				end
				if data.color_index ~= nil then
					profile.color_index = data.color_index
				end
			end)
		end
	end)
end

function M.get_level_num()
	return level_num
end

function M.get_last_finished_level_num()
	return profile.last_finished_level_num
end

local function reset()
	profile.inserted_words = {}
	inserted_word_colors = {}
	level_num = profile.last_finished_level_num + 1
	M.save_profile(true)
end

function M.set_last_finished_level_num(finished_level_num)
	profile.last_finished_level_num = finished_level_num
	reset()
end

function M.clear()
	profile.last_finished_level_num = 0
	profile.found_words_counter = 0
	reset()
end

function M.get_found_words_counter()
	return profile.found_words_counter
end

function M.set_found_words_counter(coins_count)
	profile.found_words_counter = coins_count
	events.invoke("event_found_words_counter_changed")
	M.save_profile()
end

function M.add_found_words_counter()
	profile.found_words_counter = profile.found_words_counter + 1
	events.invoke("event_found_words_counter_changed")
	M.save_profile()
end

function M.get_inserted_words()
	return profile.inserted_words
end

function M.is_contains_inserted_words(word)
	for _, w in pairs(profile.inserted_words) do
		if w == word then
			return true
		end
	end
	return false
end

function M.insert_word(word)
	table.insert(profile.inserted_words, word)
	M.save_profile()
end

function M.get_inserted_word_color(word)
	for w, c in pairs(inserted_word_colors) do
		if w == word then
			return c
		end
	end
	return nil
end

function M.insert_word_color(word, color)
	inserted_word_colors[word] = color
end

function M.get_color_index()
	return profile.color_index
end

function M.next_color_index()
	profile.color_index = profile.color_index + 1 <= #const.colors and
		profile.color_index + 1 or 1

	M.save_profile()
	return profile.color_index
end

function M.set_color_index(index)
	profile.color_index = index
	M.save_profile()
end

function M.save_profile(fast)
	if initialized then
		fast = fast ~= nil and fast or false
		yagames.player_set_data(profile, fast, function() print("save profile") end)
	end
end

return M