local cond = vim.env.NVIM_KEYCASTR ~= "1"
local function config()
  require("which-key").setup({})

  local opts = require("keymaps").opts

  vim.keymap.set("n", "<leader>?", ":WhichKey<CR>", opts)
  vim.keymap.set("i", "<C-?>", ":WhichKey i<CR>", opts)
end

---@type LazySpec
local spec = { "https://github.com/folke/which-key.nvim", config = config, cond = cond }
return spec
