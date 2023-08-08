local function status_config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>gs", "git_status", { sources = { { name = "git_status" } } })
end

local function log_config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>gl", "git_log", { sources = { { name = "git_log" } } })
end

local function stash_config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>gS", "git_stash", { sources = { { name = "git_stash" } } })
end


---@type LazySpec[]
local spec = {
  { "kuuote/ddu-source-git_status", dependencies = { "Shougo/ddu.vim" }, config = status_config },
  { "kyoh86/ddu-source-git_log", dependencies = { "Shougo/ddu.vim" }, config = log_config },
  {
    "peacock0803sz/ddu-source-git_stash",
    dev = true,
    dependencies = { "Shougo/ddu.vim" },
    config = stash_config,
  },
}
return spec
