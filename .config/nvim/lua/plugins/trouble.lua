local function config()
  local opts = require("keymaps").opts

  vim.keymap.set("n", "<Space>xx", "<Cmd>TroubleToggle<CR>", opts)
  vim.keymap.set("n", "<Space>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", opts)
  vim.keymap.set("n", "<Space>xd", "<Cmd>TroubleToggle document_diagnostics<CR>", opts)
  vim.keymap.set("n", "<Space>xl", "<Cmd>TroubleToggle loclist<CR>", opts)
  vim.keymap.set("n", "<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", opts)
  vim.keymap.set("n", "<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", opts)
end

---@type LazySpec
local spec = {
  "https://github.com/folke/trouble.nvim",
  dependencies = {
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-tree/nvim-web-devicons",
  },
  config = config,
}
return spec
