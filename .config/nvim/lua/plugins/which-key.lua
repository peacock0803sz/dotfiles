local opts = require("keymaps").opts

vim.keymap.set("n", "<leader>?", ":WhichKey<CR>", opts)
vim.keymap.set("i", "<C-?>", ":WhichKey i<CR>", opts)

local spec = {
	"folke/which-key.nvim",
	config = function()
		require("which-key").setup({})
	end,
}
return spec
