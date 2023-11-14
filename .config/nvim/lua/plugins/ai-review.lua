local function config()
  vim.fn["ai_review#config"]({ chat_gpt = { model = "gpt-3.5-turbo" } })
end

---@type LazySpec
local spec = {
  "https://github.com/yuki-yano/ai-review.vim",
  config = config,
  dependencies = { "https://github.com/Shougo/ddu.vim", "https://github.com/vim-denops/denops.vim" },
}

return spec
