local M = {}

M.N_FIELD_LETTER_BACK = hash("field_letter_back")
M.N_FIELD_LETTER_TEXT = hash("field_letter_text")
M.N_CONNECTOR_CENTER = hash("connector_center")
M.N_CONNECTOR = hash("connector")
M.N_FOUND_WORDS_COUNTER_TEXT = hash("found_words_counter_text")
M.N_ENTERED_WORD = hash("entered_word")
M.N_ENTERED_WORD_TEXT = hash("entered_word_text")

M.MSG_LAYOUT_CHANGED = hash("layout_changed")
M.MSG_LAYOUT_CHANGED = hash("layout_changed")
M.MSG_ID_PORTRAIT = hash("MyPortrait")

M.DICTIONARY_PATH = "/dictionary/russian_nouns.txt"

M.VECTOR_3_ONE = vmath.vector3(1, 1, 1)
M.VECTOR_3_ZERO = vmath.vector3(0, 0, 0)

M.EMPTY_COLOR = vmath.vector4(0.9, 0.9, 0.9, 1)
M.COLORS = {
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

M.DIRECTIONS = {
	NONE = -1,
	RIGHT = 0,
	LEFT = 180,
	TOP = 90,
	BOTTOM = 270
}

M.SCREENS = {
	GAME_SCREEN = "game_screen",
	WIN_SCREEN = "win_screen"
}

return M