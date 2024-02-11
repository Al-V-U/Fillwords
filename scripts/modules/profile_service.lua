local profile = require("scripts.modules.data.profile")
local events = require 'scripts.modules.events'
local yagames = require("yagames.yagames")
local const = require("scripts.modules.data.const")

local M = {}

local initialized = false
local yagames_initialized = false
local level_num = 1
local inserted_word_colors = {}
local init_callback = nil

local function setup_data(data)
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
	if data.found_words ~= nil then
		profile.found_words = data.found_words
	end
	if data.color_index ~= nil then
		profile.color_index = data.color_index
	end
end

local function get_data()
	yagames.player_get_data(nil, function(self, err, data)
		print("yagames.player_get_data:", err or pprint(data))
		if not err then
			setup_data(data)
		end
		initialized = true
		init_callback()
	end)
end

local function init_local()
	local game_name = sys.get_config("project.title")
	local save_path = sys.get_save_file(game_name, "profile")
	if sys.exists(save_path) then
		local data = sys.load(save_path)
		if data ~= nil then
			setup_data(data)
		end
	end
	initialized = true
	init_callback()
end

function M.init(err, callback)
	init_callback = callback
	if err then
		init_local()
	else
		yagames.player_init({ scopes = false }, function(self, err)
			if not err then
				yagames_initialized = true
				get_data()
			else
				--print("yagames player not inited:", err or pprint(data))
				init_local()
			end
		end)
	end
end

function M.profile_ready()
	return initialized
end

function M.get_level_num()
	return level_num
end

function M.get_last_finished_level_num()
	return profile.last_finished_level_num
end

local function reset()
	profile.inserted_words = {}
	profile.found_words = {}
	inserted_word_colors = {}
	level_num = profile.last_finished_level_num + 1
	M.save_profile(true)
end

function M.finish_level()
	M.set_last_finished_level_num(M.get_level_num())
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

function M.get_inserted_words()
	return profile.inserted_words
end

function M.get_inserted_words_count()
	return profile.inserted_words == nil and 0 or #profile.inserted_words
end

function M.is_contains_inserted_words(word)
	for _, w in pairs(profile.inserted_words) do
		if w == word then
			return true
		end
	end
	return false
end

local function insert_word_color(word, color_index)
	inserted_word_colors[word] = color_index
end

function M.insert_word(word, save)
	if save and not M.is_contains_inserted_words(word) then
		table.insert(profile.inserted_words, word)
	end
	insert_word_color(word, M.get_color_index())
	M.next_color_index(save)
end

function M.get_inserted_word_color(word)
	for w, c in pairs(inserted_word_colors) do
		if w == word then
			return c
		end
	end
	return nil
end

local function is_contains_found_word(word)
	for _, w in pairs(profile.found_words) do
		if w == word then
			return true
		end
	end
	return false
end

function M.reset_found_words_counter()
	if profile.found_words_counter ~= 0 then
		profile.found_words_counter = 0
		events.invoke("event_found_words_counter_changed")
		M.save_profile()
	end
end

local function add_found_words_counter()
	profile.found_words_counter = profile.found_words_counter + 1
	events.invoke("event_found_words_counter_changed")
end

function M.add_found_word(word)
	if not is_contains_found_word(word) then
		table.insert(profile.found_words, word)
		add_found_words_counter()
		M.save_profile()
		return true
	end
	return false
end

function M.get_color_index()
	return profile.color_index
end

function M.next_color_index(save)
	profile.color_index = profile.color_index + 1 <= #const.colors and
		profile.color_index + 1 or 1

	if save then
		M.save_profile()
	end
end

function M.set_color_index(index)
	profile.color_index = index
	M.save_profile()
end

function M.save_profile(fast)
	if yagames_initialized then
		fast = fast ~= nil and fast or false
		yagames.player_set_data(profile, fast, function() print("save profile") end)
	else
		local game_name = sys.get_config("project.title")
		local save_path = sys.get_save_file(game_name, "profile")
		if not sys.save(save_path, profile) then
			print("save profile error!")
		end
		print(save_path)
	end
end

return M