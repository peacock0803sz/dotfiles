local function config()
  require("fidget").setup({})
  vim.cmd([[
    highlight link FidgetTitle EndOfBuffer
    highlight link FidgetTask EndOfBuffer
  ]])
end

local spec = { "j-hui/fidget.nvim", config = config, branch="legacy" }
return spec
