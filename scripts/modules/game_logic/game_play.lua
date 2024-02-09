local M = {}

function M.start_play(self, callback)
	print("level", self.level)
	timer.delay(3, false, callback)
end

return M