local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>fu", "mru", { sources = { { name = "mr" } } }, true)
  map_source("<Space>fw", "mru", { sources = { { name = "mr" } } }, true)
end

---@type LazySpec
local spec = {
  "kuuote/ddu-source-mr",
  dependencies = {
    "Shougo/ddu.vim",
    "Shougo/ddu-kind-file",
    "lambdalisue/mr.vim",
  },
  config = config,
}
return spec
