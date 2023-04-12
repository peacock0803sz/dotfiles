local function config()
  require("nightfox").setup({
    transparent = true,
    terminal_colors = true,
  })
  vim.cmd("colorscheme nordfox")
end

local spec = { "EdenEast/nightfox.nvim", config = config }
return spec
