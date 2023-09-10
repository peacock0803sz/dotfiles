local function config()
  require("ccc").setup({
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  })
end

---@type LazySpec
local spec = { "uga-rosa/ccc.nvim", config = config }
return spec
