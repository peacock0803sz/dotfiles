local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>dF", "file", { ui = "filer", sources = { { name = "file" } } })
end

local spec = { "Shougo/ddu-source-file", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
