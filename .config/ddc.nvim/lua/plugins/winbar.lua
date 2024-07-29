local function config()
  require("barbecue").setup()
end

---@type LazySpec
local spec = {
  "https://github.com/utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  config = config,
  dependencies = {
    "https://github.com/SmiteshP/nvim-navic",
    "https://github.com/nvim-tree/nvim-web-devicons",
  },
}
return spec
