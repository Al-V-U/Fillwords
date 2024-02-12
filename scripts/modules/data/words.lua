local const = require("scripts.modules.data.const")
local M = {}

local words = {}

function M.load_words()
	local file = sys.load_resource(const.DICTIONARY_PATH)
	if file == nil then
		return
	end

	for word in file:gmatch("[^\r\n]+") do
		local len = utf8.len(word)
		if len >= 3 then
			if words[len] == nil then
				words[len] = {}
			end
			words[len][word] = 1
		end
	end
end

function M.check_word(link)
	local word = ""
	for _, slot in pairs(link) do
		word = word .. slot.letter
	end
	word = utf8.lower(word)
	local len = utf8.len(word)
	if words[len] == nil then
		return nil
	end

	if words[len][word] then
		return word
	end
end

return M