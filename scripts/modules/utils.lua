_G.original_print = print
print = function(...)
	_G.original_print(...)
	_G.original_print(debug.traceback())
end