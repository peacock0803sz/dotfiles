local function config()
  local helper = require("plugins.ddu.map")
  helper.map("<Space>dfr", "mrr", { sources = { { name = "mr", params = { kind = "mrr" } } } })
  helper.map("<Space>dfw", "mrw", { sources = { { name = "mr", params = { kind = "mrw" } } } })
  helper.map("<Space>dfu", "mru", { sources = { { name = "mr", params = { kind = "mru" } } } })
end

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
