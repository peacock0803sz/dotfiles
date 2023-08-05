local opts = require("keymaps").opts

vim.keymap.set("n", "<Space>xx", "<Cmd>TroubleToggle<CR>", opts)
vim.keymap.set("n", "<Space>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", opts)
vim.keymap.set("n", "<Space>xd", "<Cmd>TroubleToggle document_diagnostics<CR>", opts)
vim.keymap.set("n", "<Space>xl", "<Cmd>TroubleToggle loclist<CR>", opts)
vim.keymap.set("n", "<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", opts)
vim.keymap.set("n", "<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", opts)

local spec = {
	"folke/trouble.nvim",
	dependencies = { "mason.nvim", "nvim-lspconfig", "nvim-tree/nvim-web-devicons" },
}
return spec
