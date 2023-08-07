local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source(
    "<Space>ff",
    "file_external",
    { sources = { { name = "file_external", params = { resume = true } } } }
  )
end

local spec =
  { "matsui54/ddu-source-file_external", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
