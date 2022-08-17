local opts = { noremap=true, silent=true }
-- c-mode
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", opts)
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", opts)
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", opts)
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", opts)
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", opts)
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", opts)

-- scroll
vim.api.nvim_set_keymap("", "<ScrollWheelUp>", "<C-Y>", opts)
vim.api.nvim_set_keymap("", "<ScrollWheelDown>", "<C-E>", opts)

-- tab
vim.api.nvim_set_keymap("n", "[TABCMD]", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<leader>t", "[TABCMD]", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]f", ":<C-u>tabfirst<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]l", ":<C-u>tablast<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]n", ":<C-u>tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]N", ":<C-u>tabNext<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]p", ":<C-u>tabprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]e", ":<C-u>tabedit<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]w", ":<C-u>tabclose<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]o", ":<C-u>tabonly<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]c", ":<C-u>tabs<CR>", opts)
vim.api.nvim_set_keymap("n", "[TABCMD]s", ":<C-u>tabnew<CR>", opts)
