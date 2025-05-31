local util = require("lspconfig.util")

---@type vim.lsp.Config
local config = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "astro",
  },
  root_dir = util.root_pattern({ "package.json", "node_modules" }),
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.env.HOME .. "/.nix-profile/lib/node_modules/@vue/language-server",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  single_file_support = false,
  autostart = false,
}
return config
