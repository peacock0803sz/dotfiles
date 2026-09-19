local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>j", "jumplist", { sources = { { name = "jumplist" } } })
end

---@type LazySpec
local spec = {
  "https://github.com/kamecha/ddu-source-jumplist",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
