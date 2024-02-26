local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddu/sourceOptions/file.ts"
  vim.fn["ddu#custom#load_config"](path)

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
