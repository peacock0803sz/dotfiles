require("nightfox").setup({
  transparent = true,
  terminal_colors = true,
})

if vim.o.background == "light" then
  vim.cmd.colorscheme("dawnfox")
else
  vim.cmd.colorscheme("nordfox")
end

vim.api.nvim_create_user_command("ToggleColorscheme", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
    vim.cmd.colorscheme("dawnfox")
  else
    vim.o.background = "dark"
    vim.cmd.colorscheme("nordfox")
  end
end, {
  nargs = 0,
})

vim.cmd([[
  highlight NonText ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE

  highlight! FidgetTitle guibg=NONE ctermbg=NONE
  highlight! FidgetTask guibg=NONE ctermbg=NONE
]])
