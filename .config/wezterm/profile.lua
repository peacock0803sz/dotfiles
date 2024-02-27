local M = {}

local wezterm = require("wezterm")

---@param name string
---@param config table
function M.set_profile(name, config)
  wezterm.on("SwitchTo." .. name, function(window)
    local overrides = window:get_config_overrides() or {}

    for key, value in pairs(config) do
      if not overrides[key] then
        overrides[key] = value
      else
        overrides[key] = nil
      end
    end

    window:set_config_overrides(config)
  end)
end

return M
