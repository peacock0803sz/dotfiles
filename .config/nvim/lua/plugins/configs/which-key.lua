local opts = require("keymaps").opts

require('which-key').setup{}

vim.api.nvim_set_keymap("n", "<leader>?", ":WhichKey<CR>", opts)
vim.api.nvim_set_keymap("i", "<C-?>", ":WhichKey i<CR>", opts)
