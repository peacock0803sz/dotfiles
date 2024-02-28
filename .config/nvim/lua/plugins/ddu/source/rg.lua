local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>fg", "rg", { sources = { { name = "rg" } } })
end

---@type LazySpec
local spec = {
  "https://github.com/shun/ddu-source-rg",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
