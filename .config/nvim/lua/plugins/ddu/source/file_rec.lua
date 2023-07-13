local function config()
  local helper = require("plugins.ddu.map")
  helper.map("<Space>dff", "file_rec", { sources = { { name = "file_rec" } } })
end

local spec = { "Shougo/ddu-source-file_rec", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
