local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>F", "file", { ui = "filer", sources = { { name = "file" } } })
end

---@type LazySpec
local spec = {
  "https://github.com/Shougo/ddu-source-file",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
