local function config()
  local config_dir = vim.fn.stdpath("config")
  local dir = config_dir .. "/ddu/main.ts"
  vim.fn["ddu#custom#load_config"](dir)
end

local spec = {
  {
    "Shougo/ddu.vim",
    config = config,
    dependencies = { "vim-denops/denops.vim" },
  },
  { "Shougo/ddu-source-action" },
  { import = "plugins.ddu.ui" },
  { import = "plugins.ddu.kind" },
  { import = "plugins.ddu.filter" },
  { import = "plugins.ddu.source" },
}

return spec
