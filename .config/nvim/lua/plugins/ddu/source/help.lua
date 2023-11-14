local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>h", "help", { sources = { { name = "help" } } }, true)
end

---@type LazySpec
local spec = {
  "https://github.com/uga-rosa/ddu-source-help",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
