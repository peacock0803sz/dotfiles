---@type LazySpec
local spec = {
  "https://github.com/epwalsh/obsidian.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "peacock0803sz",
        path = "~/Documents/obsidian/",
      },
    },
  },
}
return spec
