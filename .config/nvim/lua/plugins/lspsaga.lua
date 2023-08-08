local opts = require("keymaps").opts

-- mappings
-- vim.keymap.set("n", "<space>rn", "<Cmd>Lspsaga rename<CR>", opts)
-- vim.keymap.set("n", "<space>ca", "<Cmd>Lspsaga code_action<CR>", opts)
-- vim.keymap.set("x", "<space>ca", "<Cmd>Lspsaga range_code_action<CR>", opts)
-- vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
-- vim.keymap.set("n", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
-- vim.keymap.set("n", "<space>gd", "<Cmd>Lspsaga preview_definetion<CR>", opts)
-- vim.keymap.set("n", "<space>e", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
-- vim.keymap.set("n", "<space>]g", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
-- vim.keymap.set("n", "<space>[g", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

---@type LazySpec
local spec = { "glepnir/lspsaga.nvim" }
return spec
