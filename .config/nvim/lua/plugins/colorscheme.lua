local function config()
  vim.cmd("colorscheme catppuccin")
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      telescope = true,
    },
  })
end

local spec = { "catppuccin/nvim", name = "catppuccin", config = config }
return spec
