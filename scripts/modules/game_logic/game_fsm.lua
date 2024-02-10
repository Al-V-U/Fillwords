local machine = require("scripts.modules.statemachine")
local level = require("scripts.modules.data.level")
local level_creator = require("scripts.modules.game_logic.level_creator")
local profile_service = require("scripts.modules.profile_service")
local game_play = require("scripts.modules.game_logic.game_play")
local monarch = require "monarch.monarch"

local M ={}

local function fsm_onloading(self)
	level.load_level()
	self.fsm:build()
end

local function fsm_oncreate(self)
	level_creator.create(self)
	self.fsm:apply_saved()
end

local function fsm_onapply(self)
	print "apply"
	self.fsm:show_level()
end

local function fsm_onshow(self)
	print "show"
	self.fsm:play_game()
end

local function fsm_onplay(self, event, from, to)
	print "play"
	game_play.start_play(self, function()
		self.fsm:win_game()
	end)
	--return fsm.ASYNC -- tell machine to defer next state until we call transition
end

local function fsm_onwin(self)
	print "win"
	profile_service.finish_level()
	self.fsm:complete()
end

local function fsm_onfinish(self)
	print("finish")
	self.fsm = nil
	monarch.replace("win_screen")
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
end

function M.input(self, action_id, action)
	if self.fsm.is(M.states.play) then
		game_play.input(self, action_id, action)
	end
end

return M