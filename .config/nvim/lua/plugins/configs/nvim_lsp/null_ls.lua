local null_ls = require("null-ls")

-- sources setup
local sources = {
  -- JavaScript
  null_ls.builtins.formatting.prettier,
  -- Python
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.formatting.black
}
null_ls.setup({
  -- debug = true,
  sources = sources,
  on_attach = require("plugins.configs.nvim_lsp.nvim_lsp").on_attach,
})
