---@type LazySpec[]
local spec = {
  { "folke/neodev.nvim" },
  { "vim-jp/vimdoc-ja" },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "lambdalisue/nerdfont.vim" },
  { "EdenEast/nightfox.nvim" },
  { "lambdalisue/guise.vim" },
  { "onsails/lspkind.nvim" },
  { "SmiteshP/nvim-navic" },
  { "folke/neodev.nvim" },
  { "machakann/vim-sandwich" },
  { "cohama/lexima.vim" },
  { "lambdalisue/suda.vim" },
  { "mattn/emmet-vim" },
  { "rhysd/committia.vim" },
  { "tani/glance-vim", dependencies = "vim-denops/denops.vim" },
  { "lambdalisue/gin.vim", dependencies = "vim-denops/denops.vim" },
  -- { "peacock0803sz/gin.vim", dependencies = "vim-denops/denops.vim", dev = true },
  { "skanehira/denops-docker.vim", dependencies = "vim-denops/denops.vim" },
  { "tyru/open-browser-github.vim", dependencies = "tyru/open-browser.vim" },
}
return spec
