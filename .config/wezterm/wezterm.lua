local wezterm = require("wezterm")
local keymaps = require("keymaps")
local set_profile = require("profile").set_profile

local config = {
  -- Window
  initial_cols = 180,
  initial_rows = 60,
  window_background_opacity = 0.8,
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
  keys = keymaps,

  -- default_gui_startup_args = { "connect", "unix" },
  unix_domains = { { name = "unix" } },
}

-- Config Overrides
wezterm.on("SwitchTo.Default", function(window)
  window:set_config_overrides(config)
end)
set_profile("Presentation", {
  font_size = 24.0,
  window_background_opacity = 0.8,
})
set_profile("Mobile", {
  font_size = 14.0,
  window_background_opacity = 0.8,
})
set_profile("ScreenShare", {
  font_size = 16.0,
  window_background_opacity = 0.8,
})

return config
