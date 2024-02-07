---@type LazySpec[]
local spec = {
  { "https://github.com/vim-jp/vimdoc-ja" },
  { "https://github.com/nvim-lua/plenary.nvim",   lazy = true },
  { "https://github.com/lambdalisue/nerdfont.vim" },
  { "https://github.com/lambdalisue/guise.vim" },
  { "https://github.com/onsails/lspkind.nvim" },
  { "https://github.com/machakann/vim-sandwich" },
  { "https://github.com/lambdalisue/suda.vim" },
  { "https://github.com/lambdalisue/vim-pager" },
  { "https://github.com/lambdalisue/vim-manpager" },
  { "https://github.com/mattn/emmet-vim" },
  { "https://github.com/rhysd/committia.vim" },
  {
    "https://github.com/lambdalisue/gin.vim",
    dependencies = "https://github.com/vim-denops/denops.vim",
  },
  {
    "https://github.com/skanehira/denops-docker.vim",
    dependencies = "https://github.com/vim-denops/denops.vim",
  },
}
return spec
