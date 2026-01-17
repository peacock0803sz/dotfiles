local ok, servers = pcall(require, "lsp._nodejs")
if ok then
  vim.lsp.config("ts_ls", servers.ts_ls)
  vim.lsp.config("cssls", servers.cssls)
end

---@type vim.lsp.Config
local astro = {
  init_options = {
    typescript = { tsdk = vim.env.HOME .. "/.nix-profile/lib/node_modules/typescript/lib/" },
  },
}
vim.lsp.config("astro", astro)

vim.lsp.enable({ "astro", "cssls", "tailwindcss", "ts_ls", "unocss" })
