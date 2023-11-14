local function config()
  local config_dir = vim.fn.stdpath("config")
  local dir = config_dir .. "/ddu/main.ts"
  vim.fn["ddu#custom#load_config"](dir)
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/Shougo/ddu.vim",
    config = config,
    dependencies = { "https://github.com/vim-denops/denops.vim" },
  },
  { import = "plugins.ddu.ui" },
  { import = "plugins.ddu.kind" },
  { import = "plugins.ddu.filter" },
  { import = "plugins.ddu.source" },
}

return spec
