local util = require("lspconfig.util")

---@type vim.lsp.Config
local config = {
  filetypes = { "typescript" },
  root_dir = util.root_pattern({ "deno.json", "deno.jsonc", "deps.ts" }),
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://npmjs.com"] = true,
          },
        },
      },
    },
  },
  single_file_support = true,
  autostart = false,
}
return config
