local machine = require("scripts.modules.statemachine")
local level = require("scripts.modules.game_logic.level")
local game_play = require("scripts.modules.game_logic.game_play")
local monarch = require "monarch.monarch"

local M ={}

function M.init(self)
	local game_screen_self = self
	local fsm = machine.create({

		initial = "initial",

		events = {
			{ name = "load", from = "initial", to = "loading" },
			{ name = "build", from = "loading", to = "create" },
			{ name = "apply_saved", from = "create", to = "apply" },
			{ name = "show_level", from = "apply", to = "show" },
			{ name = "play_game", from = "show", to = "play" },
			{ name = "win_game", from = "play", to = "win" },
			{ name = "complete", from = "win", to = "finish" }
		},

		callbacks = {

			--onleavecreate = function() print("create leave") end,

			onleavemenu = function(fsm, name, from, to)
				manager.fade('fast', function()
					fsm:transition(name)
				end)
				return fsm.ASYNC -- tell machine to defer next state until we call transition (in fadeOut callback above)
			end,

			onleavegame = function(fsm, name, from, to)
				manager.slide('slow', function()
					fsm:transition(name)
				end)
				return fsm.ASYNC -- tell machine to defer next state until we call transition (in slideDown callback above)
			end,
		}
	})

	function fsm.onloading(self, event, from, to)
		print "loading"
		level.load_level()
		print("to", to)
		fsm:build()
	end

	function fsm.oncreate(self, event, from, to)
		print("create", event, from, to)
		fsm:apply_saved()
	end

	function fsm.onapply(self, event, from, to)
		print "apply"
		fsm:show_level()
	end

	function fsm.onshow(self, event, from, to)
		print "show"
		fsm:play_game()
	end

	function fsm.onplay(self, event, from, to)
		print "play"
		game_play.start_play(game_screen_self, function()
			fsm:win_game()
		end)
		return fsm.ASYNC -- tell machine to defer next state until we call transition (in slideDown callback above)
	end

	function fsm.onwin(self, event, from, to)
		print "win"
		fsm:complete()
	end

	function fsm.onfinish(self, event, from, to)
		print("finish")
		fsm = nil
		monarch.replace("win_screen")
	end

	fsm:load()
end

return M