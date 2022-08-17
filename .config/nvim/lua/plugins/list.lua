vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use {'wbthomason/packer.nvim'}
  use {'vim-jp/vimdoc-ja'}

  use {'nvim-lua/plenary.nvim'}
  use {'kyazdani42/nvim-web-devicons'}
  use {'lambdalisue/nerdfont.vim'}

  use { "EdenEast/nightfox.nvim", run = ":NightfoxCompile", }

  use {'nvim-lualine/lualine.nvim'}
  use {'akinsho/bufferline.nvim'}

  use {'vim-denops/denops.vim'}
  use {'skanehira/denops-docker.vim'}

  use {'neovim/nvim-lspconfig'}
  use {'williamboman/mason.nvim'}
  use {'williamboman/mason-lspconfig.nvim'}
  use {'kkharji/lspsaga.nvim'}

  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-path'}
  use {'hrsh7th/cmp-cmdline'}
  use {'hrsh7th/nvim-cmp'}
  use {'L3MON4D3/LuaSnip'}
  use {'saadparwaiz1/cmp_luasnip'}

  use {'nvim-treesitter/nvim-treesitter', {run=':TSUpdate'}}

  use {"nvim-telescope/telescope.nvim"}

  use {'kien/rainbow_parentheses.vim'}
  use {'machakann/vim-sandwich'}
  use {'cohama/lexima.vim'}
  use {'monaqa/dial.nvim'}
  use {'lambdalisue/suda.vim'}

  use {'rhysd/committia.vim'}
  use {'lambdalisue/gina.vim'}
  use {'lewis6991/gitsigns.nvim'}

  use {'vim-test/vim-test'}

  use {'lambdalisue/fern.vim'}

  use {'vim-skk/skkeleton'}

  use {'thinca/vim-quickrun'}
  use {'folke/which-key.nvim'}
end)
