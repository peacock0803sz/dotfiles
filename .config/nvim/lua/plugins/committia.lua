local function config()
  vim.g.committia_open_only_vim_starting = 0
end

---@type LazySpec
local spec = { "https://github.com/rhysd/committia.vim", config = config }
return spec
