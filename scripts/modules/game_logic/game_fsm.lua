local machine = require("scripts.modules.statemachine")
local level = require("scripts.modules.data.level")
local level_creator = require("scripts.modules.game_logic.level_creator")
local profile_service = require("scripts.modules.profile_service")
local game_play = require("scripts.modules.game_logic.game_play")
local apply_saved = require("scripts.modules.game_logic.apply_saved")
local start_level_animator = require("scripts.modules.game_logic.start_level_animator")
local found_words_counter = require("scripts.modules.game_logic.found_words_counter")
local monarch = require "monarch.monarch"
local const = require("scripts.modules.data.const")

local M ={}

local function fsm_onloading(self)
	level.load_level()
end

local function fsm_oncreate(self)
	level_creator.create(self)
end

local function fsm_onapply(self)
	apply_saved.apply(self)
	found_words_counter.init()
end

local function fsm_onshow(self)
	print "show"
	start_level_animator.animate(self,
		function()
			print "show end"
			self.fsm:play_game()
		end
	)
end

local function fsm_onplay(self)
	print "play"
	game_play.start_play(self,
		function()
			self.fsm:win_game()
		end
	)
end

local function fsm_onwin(self)
	print "win"
	found_words_counter.final()
	profile_service.finish_level()
	timer.delay(1, false,
		function()
			self.fsm:complete()
		end
	)
end

local function fsm_onfinish(self)
	print("finish")
	self.fsm = nil
	monarch.replace(const.screens.win_screen)
end

M.states = {
	initial = "initial",
	loading = "loading",
	create = "create",
	apply = "apply",
	show = "show",
	play = "play",
	win = "win",
	finish = "finish"
}

function M.init(self)
	local game_screen_self = self
	self.fsm = machine.create({
		initial = "initial",

		events = {
			{ name = "load", from = M.states.initial, to = M.states.loading },
			{ name = "build", from = M.states.loading, to = M.states.create },
			{ name = "apply_saved", from = M.states.create, to = M.states.apply },
			{ name = "show_level", from = M.states.apply, to = M.states.show },
			{ name = "play_game", from = M.states.show, to = M.states.play },
			{ name = "win_game", from = M.states.play, to = M.states.win },
			{ name = "complete", from = M.states.win, to = M.states.finish }
		},

		callbacks = {
			onloading = function(self, event, from, to) fsm_onloading(game_screen_self) end,
			oncreate = function(self, event, from, to) fsm_oncreate(game_screen_self) end,
			onapply = function(self, event, from, to) fsm_onapply(game_screen_self) end,
			onshow = function(self, event, from, to) fsm_onshow(game_screen_self) end,
			onplay = function(self, event, from, to) fsm_onplay(game_screen_self) end,
			onwin = function(self, event, from, to) fsm_onwin(game_screen_self) end,
			onfinish = function(self, event, from, to) fsm_onfinish(game_screen_self) end
		}
	})

	self.fsm:load()
	self.fsm:build()
	self.fsm:apply_saved()
	self.fsm:show_level()
end

function M.input(self, action_id, action)
	if self.fsm:is(M.states.play) then
		game_play.input(self, action_id, action)
		return self.druid:on_input(action_id, action)
	end
	return false
end

return M