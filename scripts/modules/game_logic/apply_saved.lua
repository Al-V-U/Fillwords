local level = require("scripts.modules.data.level")
local game_play = require("scripts.modules.game_logic.game_play")
local profile_service = require("scripts.modules.profile_service")
local const = require("scripts.modules.data.const")
local game_play_data = require("scripts.modules.data.game_play_data")

local M = {}

local function calc_start_color_index()
	local inserted_words_count = profile_service.get_inserted_words_count()
	if inserted_words_count == nil or inserted_words_count == 0 then
		return false
	end
	local color_index = profile_service.get_color_index()
	for i = 1, inserted_words_count do
		color_index = color_index - 1
		if color_index < 1 then
			color_index = #const.colors
		end
	end
	profile_service.set_color_index(color_index)
	return true
end

function M.apply()
	if not calc_start_color_index() then
		return
	end

	local inserted_words = profile_service.get_inserted_words()
	for _, inserted_word in pairs(inserted_words) do
		local indexes = level.current_level.words[inserted_word]
		for _, index in pairs(indexes) do
			local x, y = level.index_to_xy(index)
			game_play.add_to_link(game_play_data.slots[x][y])
		end
		game_play.remove_link(false)
		game_play_data.link = {}
	end
	profile_service.set_color_index(profile_service.get_color_index())
end

return M