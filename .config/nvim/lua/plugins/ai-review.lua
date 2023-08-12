local function config()
  vim.fn["ai_review#config"]({ chat_gpt = { model = "gpt-3.5-turbo" } })
end

---@type LazySpec
local spec = {
  "yuki-yano/ai-review.vim",
  config = config,
  dependencies = { "Shougo/ddu.vim", "vim-denops/denops.vim" },
}

return spec
