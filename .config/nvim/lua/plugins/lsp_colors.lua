local spec = {
	"folke/lsp-colors.nvim",
	config = function()
		require("lsp-colors").setup({})
	end,
}
return spec
