local function config()
  require("ccc").setup({
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  })
end

---@type LazySpec
local spec = {
  "https://github.com/uga-rosa/ccc.nvim",
  config = config,
  ft = {
    "astro",
    "javascript",
    "javascriptreact",
    "lua",
    "typescript",
    "typescriptreact",
  }
}
return spec
