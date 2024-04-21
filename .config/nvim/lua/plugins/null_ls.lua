local function config()
  local null_ls = require("null-ls")

  -- sources setup
  local sources = {
    null_ls.builtins.formatting.prettier,
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
