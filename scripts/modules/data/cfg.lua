local M = {}

M.fade_logo_time = 0.3
M.show_logo_time = 0.5
M.fade_screen_time = 0.3

M.levels_count = 5
M.level_text = "Уровень "
M.is_portrait = false

M.field_size_landscape = 801
M.field_size_portrait = 1002
M.field_spacing_coeff = 0.95

M.text_scale_coeff = 160
M.letter_select_scale_coeff = 1.1
M.letter_normal_scale = nil
M.letter_select_scale = nil
M.cell_size = nil
M.show_level_time = 0.4
M.entered_words_text_color = vmath.vector4(0, 0, 0, 1)
M.counter_before_change_delay = 0.5

M.win_anim_letter_scale = 1.3
M.win_anim_scale_up_time = 0.09
M.win_anim_scale_down_time = 0.06
M.win_anim_letter_delay = 0.06

M.win_screen_disabled_alpha = 0.7
M.win_screen_checkmark_anim_time = 0.4
M.win_screen_checkmark_anim_delay = 0.6
M.win_screen_checkmark_start_scale = 3
M.win_screen_level_opened_back = "IconButton_Small_Orange_Circle"
M.win_screen_level_disabled_back = "IconButton_Small_Background_Circle"

M.fly_move_time = 0.4
M.fly_scale = vmath.vector3(0.4, 0.4, 1)
M.fly_scale_time = 0.3
M.fly_scale_delay = 0.2

return M