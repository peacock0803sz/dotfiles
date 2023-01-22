vim.cmd("colorscheme catppuccin")
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    telescope = true,
  }
})
