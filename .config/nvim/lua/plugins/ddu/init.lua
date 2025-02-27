local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddu/main.ts"
  vim.fn["ddu#custom#load_config"](path)
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/Shougo/ddu.vim",
    config = config,
    dependencies = { "https://github.com/vim-denops/denops.vim" },
    commit = "v10.0.0"
  },
  { import = "plugins.ddu.ui" },
  { import = "plugins.ddu.kind" },
  { import = "plugins.ddu.filters" },
  { import = "plugins.ddu.source" },
}

return spec
