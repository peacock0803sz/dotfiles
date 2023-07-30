local function status_config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>dgs", "git_status", { sources = { { name = "git_status" } } })
end

local function log_config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>dgl", "git_log", { sources = { { name = "git_log" } } })
end

local spec = {
  { "kuuote/ddu-source-git_status", dependencies = { "Shougo/ddu.vim" }, config = status_config },
  { "kyoh86/ddu-source-git_log", dependencies = { "Shougo/ddu.vim" }, config = log_config },
}
return spec
