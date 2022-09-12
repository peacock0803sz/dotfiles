local M = {}

local opts = { noremap=true, silent=true }
-- c-mode
vim.keymap.set("c", "<C-a>", "<Home>", opts)
vim.keymap.set("c", "<C-b>", "<Left>", opts)
vim.keymap.set("c", "<C-e>", "<End>", opts)
vim.keymap.set("c", "<C-f>", "<Right>", opts)
vim.keymap.set("c", "<C-n>", "<Down>", opts)
vim.keymap.set("c", "<C-p>", "<Up>", opts)

-- scroll
vim.keymap.set("", "<ScrollWheelUp>", "<C-Y>", opts)
vim.keymap.set("", "<ScrollWheelDown>", "<C-E>", opts)

-- tab
vim.keymap.set("n", "<leader>t", "<Plug>(tab)", opts)
vim.keymap.set("n", "<Plug>(tab)f", ":<C-u>tabfirst<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)l", ":<C-u>tablast<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)n", ":<C-u>tabnext<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)N", ":<C-u>tabNext<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)p", ":<C-u>tabprevious<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)e", ":<C-u>tabedit<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)w", ":<C-u>tabclose<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)o", ":<C-u>tabonly<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)c", ":<C-u>tabs<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)s", ":<C-u>tabnew<CR>", opts)

M.opts = opts
return M
