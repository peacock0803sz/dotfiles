local function config()
  require("fidget").setup({})
  vim.cmd([[
    highlight! FidgetTitle guibg=NONE ctermbg=NONE
    highlight! FidgetTask guibg=NONE ctermbg=NONE
  ]])
end

---@type LazySpec
local spec = { "https://github.com/j-hui/fidget.nvim", config = config, tag = "legacy" }
return spec
