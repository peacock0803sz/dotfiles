local function config()
  require("lsp-colors").setup({})
end

---@type LazySpec
local spec = { "https://github.com/folke/lsp-colors.nvim", config = config }
return spec
