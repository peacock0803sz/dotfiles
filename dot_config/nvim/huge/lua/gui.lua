if vim.g.neovide then
  vim.o.guifont = "UDEV Gothic NF:h12"
  vim.g.neovide_opacity = 0.9
  vim.g.transparency = 0.9
  vim.g.neovide_input_ime = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_hack = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_short_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_input_macos_option_key_is_meta = "both"

  vim.keymap.set("v", "<D-c>", '"+y')
  vim.keymap.set("n", "<D-v>", '"+P')
  vim.keymap.set("v", "<D-v>", '"+P')
  vim.keymap.set("c", "<D-v>", "<C-R>+")
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli')
end
