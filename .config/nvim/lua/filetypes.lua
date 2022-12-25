vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.njk",
  command = "set filetype=htmldjango",
})
