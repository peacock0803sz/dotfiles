local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>s", "source", { sources = { { name = "source" } } })
end

---@type LazySpec
local spec = {
  "https://github.com/4513ECHO/ddu-source-source",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
