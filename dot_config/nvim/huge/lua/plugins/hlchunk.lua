local function config()
  require("hlchunk").setup({})
end

---@type LazySpec
local spec = {
  "https://github.com/shellRaining/hlchunk.nvim",
  event = "UIEnter",
  config = config,
}
return spec
