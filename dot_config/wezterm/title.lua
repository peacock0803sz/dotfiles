local M = {}

---@param s string
---@return string
local function basename(s)
  local base = s:gsub("%2", "(.*[/\\])(.*)")
  return base
end

---@param s string
---@return string
local function omit_path(s)
  -- trim `file://` and truncate home directory
  local path = s:gsub("^[^:]*://[^/]*", ""):gsub("^" .. wezterm.home_dir, "~")

  local map_config = {
    ["~work"] = "~/ghq/github.com/topgate",
    ["~priv"] = "~/ghq/github.com/peacock0803sz",
    ["~gh"] = "~/ghq/github.com",
  }

  for key, value in pairs(map_config) do
    if path:match(value) then
      path = path:gsub(value, key)
    end
  end
  return path
end

---@param tab_info any
---@return string
local function make_title(tab_info)
  ---@type string
  local process_name = basename(tab_info.active_pane.foreground_process_name)

  if process_name == "zsh" then
    return omit_path(tab_info.active_pane.current_working_dir)
  elseif process_name ~= "" then
    return process_name
  else
    return ""
  end
end

---@return table
function M.format_tab_title(tab, tabs, panes, config, hover, max_width)
  local white = "#cdcecf"
  local black = "#2e3440"
  local title = tab.tab_index + 1 .. ": " .. make_title(tab)

  if tab.is_active then
    return {
      { Background = { Color = white } },
      { Foreground = { Color = black } },
      { Text = title },
    }
  else
    return {
      { Background = { Color = black } },
      { Foreground = { Color = white } },
      { Text = title },
    }
  end
end

---@return string
function M.format_window_title(tab, pane, tabs, panes, config)
  local workspace = wezterm.mux.get_active_workspace()
  return "[" .. workspace .. "]: " .. make_title(tab)
end

return M
