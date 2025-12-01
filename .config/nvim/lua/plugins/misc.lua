---@type LazySpec[]
local spec = {
  { "https://github.com/vim-jp/vimdoc-ja" },
  { "https://github.com/neovim/nvim-lspconfig" },
  { "https://github.com/nvim-lua/plenary.nvim", lazy = true },
  { "https://github.com/lambdalisue/vim-nerdfont" },
  { "https://github.com/lambdalisue/vim-guise" },
  { "https://github.com/onsails/lspkind.nvim" },
  { "https://github.com/machakann/vim-sandwich" },
  { "https://github.com/lambdalisue/vim-suda" },
  { "https://github.com/lambdalisue/vim-pager" },
  { "https://github.com/lambdalisue/vim-fern" },
  { "https://github.com/lambdalisue/vim-manpager" },
  { "https://github.com/mattn/emmet-vim" },
  { "https://github.com/rhysd/committia.vim" },
  {
    "https://github.com/skanehira/denops-docker.vim",
    dependencies = "https://github.com/vim-denops/denops.vim",
  },
}
return spec
