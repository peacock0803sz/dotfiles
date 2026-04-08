local utils = require("utils")

local function config()
  require("octo").setup({
    picker = "fzf-lua",
  })
end

---@type LazySpec
local spec = {
  "https://github.com/pwntester/octo.nvim",
  config = config,
  cond = utils.check_enable({ arpeggio = true }),
  dependencies = {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/ibhagwan/fzf-lua",
  },
}
return spec
