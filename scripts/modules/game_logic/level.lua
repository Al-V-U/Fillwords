local profile_service = require("scripts.modules.profile_service")
local M = {}

M.current_level = nil

function M.load_level()
	local path = "/levels/" .. string.format("%0" .. 5 .. "d" .. ".json", profile_service.get_level_num())
	--print (path)
	local json_file = sys.load_resource(path)
	if json_file == nil then
		profile_service.set_last_finished_level_num(0)
		M.load_level()
		return
	end

	local json_table = json.decode(json_file)
	M.current_level = json_table
end

return M