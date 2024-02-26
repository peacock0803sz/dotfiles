local map_source = require("plugins.ddu.map").map_source

local function status_config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddu/kindOptions/git_status.ts"
  vim.fn["ddu#custom#load_config"](path)

  map_source("<Space>gs", "git_status", { sources = { { name = "git_status" } } }, true)
end

local function log_config()
  map_source("<Space>gl", "git_log", { sources = { { name = "git_log" } } }, true)
end

local function stash_config()
  map_source("<Space>gS", "git_stash", { sources = { { name = "git_stash" } } }, true)
end

local function diff_config()
  --
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/kuuote/ddu-source-git_status",
    dependencies = { "Shougo/ddu.vim" },
    config = status_config,
  },
  {
    "https://github.com/kyoh86/ddu-source-git_log",
    dependencies = { "Shougo/ddu.vim" },
    config = log_config,
  },
  {
    "https://github.com/kuuote/ddu-source-git_diff",
    dependencies = { "Shougo/ddu.vim" },
    config = diff_config,
  },
  {
    "https://github.com/peacock0803sz/ddu-source-git_stash",
    dev = true,
    dependencies = { "https://github.com/Shougo/ddu.vim" },
    config = stash_config,
  },
}
return spec
