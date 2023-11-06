local function config()
  require("insx.preset.standard").setup({})
end

---@type LazySpec
local spec = { "hrsh7th/nvim-insx", config = config }
return spec
