local map_source = require("plugins.ddu.map").map_source

local function status_config()
  map_source("<Space>gs", "git_status", { sources = { { name = "git_status" } } }, true)
end

local function log_config()
  map_source("<Space>gl", "git_log", { sources = { { name = "git_log" } } }, true)
end

local function stash_config()
  map_source("<Space>gS", "git_stash", { sources = { { name = "git_stash" } } }, true)
end

---@type LazySpec[]
local spec = {
  { "kuuote/ddu-source-git_status", dependencies = { "Shougo/ddu.vim" }, config = status_config },
  { "kyoh86/ddu-source-git_log",    dependencies = { "Shougo/ddu.vim" }, config = log_config },
  {
    "https://github.com/peacock0803sz/ddu-source-git_stash",
    dev = true,
    dependencies = { "https://github.com/Shougo/ddu.vim" },
    config = stash_config,
  },
}
return spec
