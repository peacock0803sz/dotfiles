local function config()
	vim.keymap.set("n", "S", "<Cmd>FuzzyMotion<CR>")
end

local spec = { "yuki-yano/fuzzy-motion.vim", dependencies = { "vim-denops/denops.vim" }, config = config }
return spec
