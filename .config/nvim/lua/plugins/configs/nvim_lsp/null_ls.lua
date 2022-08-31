local null_ls = require("null-ls")

-- sources setup
local sources = {
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.formatting.black,
}
null_ls.setup({
  sources = sources
})
