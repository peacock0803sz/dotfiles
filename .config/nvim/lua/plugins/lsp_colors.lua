local function config()
  require("lsp-colors").setup({})
end

---@type LazySpec
local spec = { "folke/lsp-colors.nvim", config = config }
return spec
