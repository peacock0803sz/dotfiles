local ok, servers = pcall(require, "lsp.nodejs")
if ok then
  vim.lsp.config("cssls", servers.cssls)
end

vim.lsp.enable("cssls", "tailwindcss", "unocss")
