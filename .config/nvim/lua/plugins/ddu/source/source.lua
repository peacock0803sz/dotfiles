local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>s", "source", { sources = { { name = "source" } } })
end

---@type LazySpec
local spec = { "4513ECHO/ddu-source-source", dependencies = { "Shougo/ddu.vim" }, config = config }
return spec
