local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>fu", "mru", { sources = { { name = "mr" } } }, true)
  map_source("<Space>fw", "mru", { sources = { { name = "mr" } } }, true)
end

---@type LazySpec
local spec = {
  "https://github.com/kuuote/ddu-source-mr",
  dependencies = {
    "https://github.com/Shougo/ddu.vim",
    "https://github.com/Shougo/ddu-kind-file",
    "https://github.com/lambdalisue/mr.vim",
  },
  config = config,
}
return spec
