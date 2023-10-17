require("nightfox").setup({
  transparent = true,
  terminal_colors = true,
})

vim.cmd.colorscheme("dayfox")

vim.cmd([[
  highlight NonText ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
]])
