local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>fu", "mru", { sources = { { name = "mr", params = { kind = "mru" } } } }, true)
  map_source("<Space>fw", "mrw", { sources = { { name = "mr", params = { kind = "mrw" } } } }, true)
  map_source("<Space>fr", "mrr", { sources = { { name = "mr", params = { kind = "mrr" } } } }, true)
  map_source("<Space>fd", "mrd", { sources = { { name = "mr", params = { kind = "mrd" } } } }, true)
end

---@type LazySpec
local spec = {
  "https://github.com/kuuote/ddu-source-mr",
  dependencies = {
    "https://github.com/Shougo/ddu.vim",
    "https://github.com/Shougo/ddu-kind-file",
    "https://github.com/lambdalisue/vim-mr",
  },
  config = config,
}
return spec
