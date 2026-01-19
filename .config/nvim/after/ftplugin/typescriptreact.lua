local servers = require("lsp.nodejs")
vim.lsp.config("ts_ls", servers.ts_ls)
vim.lsp.config("cssls", servers.cssls)

vim.lsp.enable({ "cssls", "tailwindcss", "ts_ls", "unocss" })
