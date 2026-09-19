local function config()
  local null_ls = require("null-ls")

  -- sources setup
  local sources = {
    -- null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.biome,
    -- Lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.formatting.nixpkgs_fmt,
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
}
return spec
