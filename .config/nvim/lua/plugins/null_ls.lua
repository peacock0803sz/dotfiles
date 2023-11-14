local function config()
  local null_ls = require("null-ls")

  -- sources setup
  local sources = {
    -- null_ls.builtins.diagnostics.flake8.with({
    --   extra_args = { "--max-line-length", "88" },
    -- }),
    -- null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.shellcheck.with({
      filetypes = { "sh", "bash", "zsh" },
    }),
    null_ls.builtins.code_actions.shellcheck.with({
      filetypes = { "sh", "bash", "zsh" },
    }),
    -- JavaScript
    null_ls.builtins.formatting.prettier,
    -- Python
    -- null_ls.builtins.formatting.black,
    -- Lua
    null_ls.builtins.formatting.stylua,
  }
  null_ls.setup({
    -- debug = true,
    sources = sources,
  })
end

---@type LazySpec
local spec = {
  "https://github.com/nvimtools/none-ls.nvim",
  config = config,
  dependencies = { "https://github.com/williamboman/mason.nvim" },
}
return spec
