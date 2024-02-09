local M = {}

M.colors = {
	vmath.vector4(0.92, 0.41, 0.48, 1),
	vmath.vector4(0.53, 0.74, 0.43, 1),
	vmath.vector4(0.98, 0.61, 0.61, 1),
	vmath.vector4(0.42, 0.78, 0.7, 1),
	vmath.vector4(0.7, 0.42, 0.6, 1),
	vmath.vector4(0.5, 0.4, 0.6, 1),
	vmath.vector4(0.97, 0.82, 0.48, 1),
	vmath.vector4(0.84, 0.57, 0.77, 1),
	vmath.vector4(0.08, 0.56, 0.64, 1),
	vmath.vector4(0.72, 0.96, 0.67, 1),
	vmath.vector4(0.73, 0.67, 0.96, 1)
}

M.directions = {
	none = -1,
	right = 0,
	left = 180,
	top = 90,
	bottom = 270
}

return M