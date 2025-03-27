local function config()
  require("octo").setup({
    picker = "fzf-lua",
  })
end

---@type LazySpec
local spec = {
  "https://github.com/pwntester/octo.nvim",
  config = config,
  cond = false,
  dependencies = {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/ibhagwan/fzf-lua",
  },
}
return spec
