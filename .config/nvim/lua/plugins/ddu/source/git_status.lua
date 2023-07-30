local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>dgs", "git_status", { sources = { { name = "git_status" } } })
end

local spec = { "kuuote/ddu-source-git_status", dependencies = { "Shougo/ddu.vim" }, config = config }
return spec
