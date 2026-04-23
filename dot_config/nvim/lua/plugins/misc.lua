---@type LazySpec[]
local spec = {
  { "https://github.com/cocopon/inspecthi.vim" },
  { "https://github.com/vim-jp/vimdoc-ja" },
  { "https://github.com/y0za/vim-reading-vimrc" },
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
    "https://github.com/delphinus/md-render.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }, -- optional: file type icons in code blocks
      { "delphinus/budoux.lua" },        -- optional: CJK phrase-level line breaking
    },
    keys = {
      { "<Space>mp", "<Plug>(md-render-preview)",     desc = "Markdown preview (toggle)" },
      { "<Space>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
      { "<Space>md", "<Plug>(md-render-demo)",        desc = "Markdown render demo" },
    },
  },
}
return spec
