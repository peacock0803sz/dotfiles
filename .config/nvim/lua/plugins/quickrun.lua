vim.keymap.set("n", "<Space>qr", "<Cmd>QuickRun<cr>")
vim.keymap.set("v", "<Space>qr", "<Cmd>QuickRun<cr>")

vim.g.quickrun_config = {
	_ = {
		runner = "neovim_job",
		outputter = "quickfix",
	},
}

local spec = {
	"thinca/vim-quickrun",
	dependencies = "lambdalisue/vim-quickrun-neovim-job",
}
return spec
