local function config()
  local null_ls = require("null-ls")

  -- sources setup
  local sources = {
    null_ls.builtins.diagnostics.flake8.with({
      extra_args = { "--max-line-length", "88" },
    }),
    -- JavaScript
    null_ls.builtins.formatting.prettier,
    -- Python
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.black,
    -- Lua
    null_ls.builtins.formatting.stylua,
  }
  null_ls.setup({
    -- debug = true,
    sources = sources,
    on_attach = require("plugins.nvim_lsp").on_attach,
  })
end

local spec = { "jose-elias-alvarez/null-ls.nvim", config = config }
return spec
