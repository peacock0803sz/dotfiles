local servers = require("lsp.nodejs")
vim.lsp.config("vtsls", servers.vtsls)
vim.lsp.config("cssls", servers.cssls)

vim.lsp.enable({ "cssls", "tailwindcss", "vtsls", "unocss" })
