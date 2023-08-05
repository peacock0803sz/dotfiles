vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.njk",
  command = "set filetype=htmldjango",
})
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.envrc",
  command = "set filetype=shellscript",
})
