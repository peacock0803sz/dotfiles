local function config()
  require("catppuccin").setup({
    flavour = "latte",
    background = {
      light = "latte",
      dark = "mocha",
    },
    styles = {
      comments = {},
    },
    transparent_background = true,
  })
  vim.cmd.colorscheme("catppuccin")
end

---@type LazySpec
local spec = {
  "https://github.com/catppuccin/nvim",
  name = "catppuccin",
  config = config,
  lazy = false,
  priority = 1000,
}

return spec
