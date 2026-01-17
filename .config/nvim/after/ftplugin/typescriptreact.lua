local ok, servers = pcall(require, "lsp._nodejs")
if ok then
  vim.lsp.config("ts_ls", servers.ts_ls)
  vim.lsp.config("cssls", servers.cssls)
end

vim.lsp.enable({ "cssls", "tailwindcss", "ts_ls", "unocss" })
