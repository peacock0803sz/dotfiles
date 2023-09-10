local function config()
  require("which-key").setup({})

  local opts = require("keymaps").opts

  vim.keymap.set("n", "<leader>?", ":WhichKey<CR>", opts)
  vim.keymap.set("i", "<C-?>", ":WhichKey i<CR>", opts)
end

---@type LazySpec
local spec = { "folke/which-key.nvim", config = config }
return spec
