local M = {}

M.levels_count = 5
M.is_portrait = false
M.field_size_landscape = 801
M.field_size_portrait = 1002
M.field_spacing_coeff = 0.95
M.text_scale_coeff = 160
M.letter_select_scale_coeff = 1.1
M.letter_normal_scale = nil
M.letter_select_scale = nil
M.show_level_time = 0.4
M.entered_words_text_color = vmath.vector4(0, 0, 0, 1)

M.win_anim_letter_scale = 1.3
M.win_anim_scale_up_time = 0.09
M.win_anim_scale_down_time = 0.06
M.win_anim_letter_delay = 0.06

M.fly_move_time = 0.4
M.fly_scale_time = 0.3
M.fly_scale_delay = 0.2

return M