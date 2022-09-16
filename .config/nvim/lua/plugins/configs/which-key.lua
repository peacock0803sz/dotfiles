local opts = require("keymaps").opts

require('which-key').setup{}

vim.keymap.set("n", "<leader>?", ":WhichKey<CR>", opts)
vim.keymap.set("i", "<C-?>", ":WhichKey i<CR>", opts)
