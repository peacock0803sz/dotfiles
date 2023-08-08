local function config()
  vim.fn["ai_review#config"]({ chat_gpt = { model = "gpt-4" } })
end

---@type LazySpec
local spec = {
  "yuki-yano/ai-review.vim",
  config = config,
  dependencies = { "Shougo/ddu.vim", "vim-denops/denops.vim" },
  cmd = { "AiReview", "AiReviewLog" },
}

return spec
