require('which-key').setup{}

vim.api.nvim_set_keymap("n", "<leader>?", ":WhichKey<CR>", {})
vim.api.nvim_set_keymap("i", "<C-?>", ":WhichKey i<CR>", {})
