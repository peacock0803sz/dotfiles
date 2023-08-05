local function config()
	require("ccc").setup({
		highlighter = {
			auto_enable = true,
			lsp = true,
		},
	})
end

local spec = { "uga-rosa/ccc.nvim", config = config }
return spec
