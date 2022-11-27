local M = {}

local opts = { noremap = true, silent = true }
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
vim.keymap.set("n", "<space>t", "<Plug>(tab)", opts)
vim.keymap.set("n", "<Plug>(tab)f", "<Cmd>tabfirst<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)l", "<Cmd>tablast<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)n", "<Cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)N", "<Cmd>tabNext<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)p", "<Cmd>tabprevious<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)e", "<Cmd>tabedit<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)w", "<Cmd>tabclose<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)o", "<Cmd>tabonly<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)c", "<Cmd>tabs<CR>", opts)
vim.keymap.set("n", "<Plug>(tab)s", "<Cmd>tabnew<CR>", opts)

M.opts = opts
return M
