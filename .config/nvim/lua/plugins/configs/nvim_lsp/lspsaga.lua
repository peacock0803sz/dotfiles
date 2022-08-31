require("lspsaga").setup({
  --
})

local opts = require("keymaps").opts

-- mappings
vim.api.nvim_set_keymap("n", "<space>rn", ":<C-u>Lspsaga rename<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>ca", ":<C-u>Lspsaga code_action<CR>", opts)
vim.api.nvim_set_keymap("x", "<space>ca", ":<C-u>Lspsaga range_code_action<CR>", opts)
vim.api.nvim_set_keymap("n", "K", ":<C-u>Lspsaga hover_doc<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", ":<C-u>Lspsaga signature_help<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<space>gd", ":<C-u>Lspsaga preview_definetion<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>e", ":<C-u>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>]g", ":<C-u>Lspsaga diagnostic_jump_next<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>[g", ":<C-u>Lspsaga diagnostic_jump_prev<CR>", opts)
