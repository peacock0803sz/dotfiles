vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(skkeleton-toggle)", {})
vim.api.nvim_set_keymap("c", "<C-j>", "<Plug>(skkeleton-toggle)", {})

vim.fn["skkeleton#config"]({
  eggLikeNewline = true,
  showCandidatesCount = 3,
  globalJisyo = "~/ghq/github.com/skk-dev/dict/SKK-JISYO.L"
})
