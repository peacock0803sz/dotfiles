local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source(
    "<Space>fr",
    "mrr",
    { sources = { { name = "mr", resume = true, params = { kind = "mrr" } } } }
  )
  helper.map_source(
    "<Space>fw",
    "mrw",
    { sources = { { name = "mr", resume = true, params = { kind = "mrw" } } } }
  )
  helper.map_source(
    "<Space>fu",
    "mru",
    { sources = { { name = "mr", resume = true, params = { kind = "mru" } } } }
  )
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
