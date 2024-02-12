local cfg = require("scripts.modules.data.cfg")

local M = {}

function M.animate(self, callback)
	local first_callback = callback
	for _, s in pairs(self.slots) do
		for _, slot in pairs(s) do
			gui.animate(slot.back_node, "scale",
				vmath.vector3(1, 1, 1), gui.EASING_OUTCUBIC,
				cfg.show_level_time, 0, first_callback)
			first_callback = nil
		end
	end
end

return M