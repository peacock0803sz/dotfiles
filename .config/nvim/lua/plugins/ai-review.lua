local function config()
	vim.fn["ai_review#config"]({ chat_gpt = { model = "gpt-4" } })
end

local spec = {
	"yuki-yano/ai-review.vim",
	config = config,
	dependencies = { "Shougo/ddu.vim", "vim-denops/denops.vim" },
}

return spec
