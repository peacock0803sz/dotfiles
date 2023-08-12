local wezterm = require("wezterm")

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  else -- default to dark
    return "Dark"
  end
end

-- local function get_colorscheme()
--   if get_appearance() == "Light" then
--     return "dawnfox"
--   else
--     return "nordfox"
--   end
-- end

wezterm.on("window-config-reloaded", function(window, _)
  window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

return {
  -- Window
  initial_cols = 184,
  initial_rows = 54,
  window_background_opacity = 0.925,
  macos_window_background_blur = 10,
  enable_csi_u_key_encoding = true,

  -- Fonts
  font = wezterm.font_with_fallback({
    { family = "UDEV Gothic", weight = "Bold" },
    { family = "UDEV Gothic NF", weight = "Bold" },
    "Noto Color Emoji",
  }),
  font_size = 14.0,

  color_scheme = "nordfox",
  colors = {
    cursor_bg = "white",
    cursor_border = "white",
  },

  use_ime = true,

  -- Keybindings
  disable_default_key_bindings = true,
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    -- QuickSelect
    { key = "v", mods = "LEADER", action = "ActivateCopyMode" },
    -- Reload
    { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
    {
      key = "f",
      mods = "LEADER",
      action = wezterm.action({ Search = { CaseSensitiveString = "" } }),
    },
    { key = "q", mods = "CMD", action = "QuitApplication" },

    -- Clipboards
    { key = "c", mods = "SUPER", action = wezterm.action({ CopyTo = "Clipboard" }) },
    { key = "v", mods = "SUPER", action = wezterm.action({ PasteFrom = "Clipboard" }) },

    -- Font & Window Sizing
    { key = "+", mods = "ALT|SHIFT", action = "IncreaseFontSize" },
    { key = "-", mods = "ALT", action = "DecreaseFontSize" },
    { key = "0", mods = "ALT", action = "ResetFontSize" },
    { key = "0", mods = "ALT|SHIFT", action = "ResetFontAndWindowSize" },

    -- Workspaces
    {
      key = "w",
      mods = "ALT|SHIFT",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
    { key = "s", mods = "ALT|SHIFT", action = wezterm.action({ SwitchToWorkspace = {} }) },
    { key = "l", mods = "ALT", action = wezterm.action({ SwitchWorkspaceRelative = 1 }) },
    { key = "h", mods = "ALT", action = wezterm.action({ SwitchWorkspaceRelative = -1 }) },
    -- {key="1", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="0"}}},
    -- {key="2", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="1"}}},
    -- {key="3", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="2"}}},
    -- {key="4", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="3"}}},
    -- {key="5", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="4"}}},
    -- {key="6", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="5"}}},
    -- {key="7", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="6"}}},
    -- {key="8", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="7"}}},
    -- {key="9", mods="ALT|SHIFT", action=wezterm.action{SwitchToWorkspace={name="8"}}},

    -- Tabs
    {
      key = "w",
      mods = "ALT",
      action = wezterm.action({ ShowLauncherArgs = { flags = "FUZZY|TABS" } }),
    },
    { key = "s", mods = "ALT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "j", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "k", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },
    { key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },
    { key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },
    { key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },
    { key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },
    { key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },
    { key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },
    { key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },
    { key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },

    -- Panes
    {
      key = "w",
      mods = "LEADER",
      action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
    },
    {
      key = "x",
      mods = "ALT",
      action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
      key = "v",
      mods = "ALT",
      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    { key = "h", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "j", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "k", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "l", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "h", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "j", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "k", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "l", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
  },
}
