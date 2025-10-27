local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddu/kindOptions/file.ts"
  vim.fn["ddu#custom#load_config"](path)

  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>F", "file", { ui = "filer", sources = { { name = "file" } } })

  vim.api.nvim_create_user_command("DduFiles", function()
    vim.fn["ddu#start"]({
      ui = "filer",
      uiOptions = { filer = { preview = false } },
      uiParams = {
        filer = {
          split = "no",
          startAutoAction = false,
          autoAction = {},
        },
      },
      sources = { { name = "file" } },
    })
  end, {})
end

---@type LazySpec
local spec = {
  "https://github.com/Shougo/ddu-source-file",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
