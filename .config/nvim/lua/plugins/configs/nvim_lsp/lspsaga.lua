require("lspsaga").setup({
  --
})

local opts = require("keymaps").opts

-- mappings
vim.keymap.set("n", "<space>rn", ":<C-u>Lspsaga rename<CR>", opts)
vim.keymap.set("n", "<space>ca", ":<C-u>Lspsaga code_action<CR>", opts)
vim.keymap.set("x", "<space>ca", ":<C-u>Lspsaga range_code_action<CR>", opts)
vim.keymap.set("n", "K", ":<C-u>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "<C-k>", ":<C-u>Lspsaga signature_help<CR>", opts)
-- vim.keymap.set("n", "<space>gd", ":<C-u>Lspsaga preview_definetion<CR>", opts)
vim.keymap.set("n", "<space>e", ":<C-u>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.keymap.set("n", "<space>]g", ":<C-u>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "<space>[g", ":<C-u>Lspsaga diagnostic_jump_prev<CR>", opts)
