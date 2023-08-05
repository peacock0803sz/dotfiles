vim.g.user_emmet_install_global = 1
vim.g.emmet_html5 = 1
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = "*.html,*.css,*.njk",
	command = "EmmetInstall",
})

local spec = { "mattn/emmet-vim" }
return spec
