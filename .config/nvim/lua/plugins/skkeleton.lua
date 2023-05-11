vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)", {})
vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-toggle)", {})

local function config()
  vim.fn["skkeleton#config"]({
    eggLikeNewline = true,
    showCandidatesCount = 3,
    globalJisyo = "~/ghq/github.com/skk-dev/dict/SKK-JISYO.L",
  })
end

-- @type LazySpec
local spec = { "vim-skk/skkeleton", dependencies = "vim-denops/denops.vim", config = config }
return spec
