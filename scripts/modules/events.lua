-- Создание таблицы событий
local M = {}

M.events = {}

-- Функция подписки на событие
function M.subscribe(event, url_or_callback, hash_message)
	if not M.events[event] then
		M.events[event] = {}
	end
	table.insert(M.events[event], { url_or_callback = url_or_callback, message = hash_message })
end

-- Функция отписки от события
function M.unsubscribe(event, url_or_callback)
	if M.events[event] then
		for i, v in ipairs(M.events[event]) do
			if v.url_or_callback == url_or_callback then
				table.remove(M.events[event], i)
				break
			end
		end
	end
end

-- Функция вызова события
function M.invoke(event)
	if M.events[event] then
		for _, v in ipairs(M.events[event]) do
			if v.message == nil then
				v.url_or_callback()
			else
				msg.post(v.url_or_callback, v.message)
			end
		end
	end
end

return M
-- Пример использования subscribe("event1", function() print("event1 fired") end) subscribe("event2", function() print("event2 fired") end) raise("event1") raise("event2") unsubscribe("event1") raise("event1")