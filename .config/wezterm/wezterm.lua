local wezterm = require("wezterm")
local title = require("title")
local keymaps = require("keymaps")

wezterm.on("format-tab-title", title.format_tab_title)
wezterm.on("format-window-title", title.format_window_title)
wezterm.on("window-config-reloaded", function(window, _)
  window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

return {
  -- Window
  initial_cols = 180,
  initial_rows = 60,
  window_background_opacity = 0.9,
  macos_window_background_blur = 10,
  -- enable_csi_u_key_encoding = true,
  window_decorations = "NONE | RESIZE",

  -- Fonts
  font = wezterm.font_with_fallback({
    { family = "UDEV Gothic NF", weight = "Bold" },
    "Noto Color Emoji",
  }),
  font_size = 12.0,

  color_scheme = "Catppuccin Latte",

  use_ime = false,

  -- Keybindings
  disable_default_key_bindings = true,
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = keymaps
}
