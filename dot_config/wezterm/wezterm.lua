local wezterm = require("wezterm")
local keymaps = require("keymaps")
local set_profile = require("profile").set_profile

---@param hex string
---@param opacity number
local function generate_background(hex, opacity)
  local _r, _g, _b = hex:sub(2, 3), hex:sub(4, 5), hex:sub(6, 7)
  local rgba = string.format(
    "rgba(%d, %d, %d, %f)",
    tonumber(_r, 16),
    tonumber(_g, 16),
    tonumber(_b, 16),
    opacity or 1.0
  )
  local bg = { source = { Color = rgba }, height = "100%", width = "100%" }
  return bg
end

local color_scheme_name = "Catppuccin Latte"
local color_pallet = wezterm.color.get_builtin_schemes()[color_scheme_name]

local config = {
  -- Window
  initial_cols = 180,
  initial_rows = 60,
  background = {
    generate_background(color_pallet.background, 0.8),
  },
  macos_window_background_blur = 10,
  -- enable_csi_u_key_encoding = true,
  window_decorations = "NONE | RESIZE",

  -- Fonts
  font = wezterm.font_with_fallback({
    { family = "UDEV Gothic NF", weight = "Bold" },
    "Noto Color Emoji",
  }),
  font_size = 14.0,

  color_scheme = color_scheme_name,

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
  macos_window_background_blur = 50,
  background = {
    generate_background(color_pallet.background, 0.8),
  }
})
set_profile("Mobile", {
  font_size = 16.0,
})
set_profile("ScreenShare", {
  font_size = 16.0,
  macos_window_background_blur = 0,
  background = {
    generate_background(color_pallet.background, 1.0),
    {
      source = {
        File = os.getenv("HOME") .. "/Pictures/wallpapers/nixos-wallpaper-catppuccin-latte.png",
      },
      height = "Cover",
      horizontal_align = "Center",
      opacity = 0.2,
    },
  },
})

return config
