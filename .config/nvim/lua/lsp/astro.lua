---@type vim.lsp.Config
local config = {
  init_options = {
    typescript = {
      tsdk = vim.env.HOME .. "/.nix-profile/lib/node_modules/typescript/lib",
    },
  },
}
return config
