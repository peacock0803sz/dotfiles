-- Makefile
vim.api.nvim_create_augroup("makefile", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.njk",
  command = "set filetype=htmldjango",
})

-- F**K json conceal!
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.json",
  command = "set conceallevel=0",
})
