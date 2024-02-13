local events = require("scripts.modules.events")
local const = require("scripts.modules.data.const")
local profile_service = require 'scripts.modules.profile_service'

local M = {}
local text_node = nil
local before_change_delay = 0.5

local function on_counter_changed()
	timer.delay(before_change_delay, false,
		function()
			local counter = profile_service.get_found_words_counter()
			gui.set_text(text_node, counter)
		end
	)
end

function M.init()
	text_node = gui.get_node(const.N_FOUND_WORDS_COUNTER_TEXT)
	events.subscribe("event_found_words_counter_changed", on_counter_changed)
	local counter = profile_service.get_found_words_counter()
	gui.set_text(text_node, counter)
end

function M.final()
	events.unsubscribe("event_found_words_counter_changed", on_counter_changed)
end

return M