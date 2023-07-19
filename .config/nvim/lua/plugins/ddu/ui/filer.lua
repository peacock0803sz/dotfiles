local function config()
  local config_dir = vim.fn.stdpath("config")
  local dir = config_dir .. "/ddu/ui/filer.ts"
  vim.fn["ddu#custom#load_config"](dir)
end


local spec = {
  { "Shougo/ddu-ui-filer",       config = config, dependencies = "Shougo/ddu.vim" },
  { "Shougo/ddu-column-filename" },
}

return spec
