local util = require("lspconfig.util")

---@type vim.lsp.Config
local config = {
  cmd = { vim.env.HOME .. "/.nix-profile/bin/vue-language-server" },
  autostart = true,
  root_dir = util.root_pattern({ "package.json" }),
  single_file_support = true,
  init_options = {
    typescript = {
      tsdk = vim.env.HOME .. "/.nix-profile/lib/node_modules/typescript/lib",
    },
    vue = {
      hybridMode = false,
    },
  },
}
return config
