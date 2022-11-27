vim.g.user_emmet_install_global = 0
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*.html,*.css,*.njk",
  command = "EmmetInstall",
})
