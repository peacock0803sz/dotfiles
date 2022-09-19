-- @NoSpell
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' }
  use { 'vim-jp/vimdoc-ja' }

  use { 'nvim-lua/plenary.nvim' }
  use { 'lambdalisue/nerdfont.vim' }

  use { "EdenEast/nightfox.nvim", run = ":NightfoxCompile", }

  use { 'nvim-lualine/lualine.nvim' }
  use { 'akinsho/bufferline.nvim' }

  if vim.env.lsp_provider == "nvim_lsp" then
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer', after = { 'nvim-cmp' } }
    use { 'hrsh7th/cmp-path', after = { 'nvim-cmp' } }
    use { 'hrsh7th/cmp-cmdline', after = { 'nvim-cmp' } }
    use { 'hrsh7th/cmp-omni', after = { 'nvim-cmp' } }
    use { 'f3fora/cmp-spell', after = { 'nvim-cmp' } }

    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }

    use { 'neovim/nvim-lspconfig' }
    use { 'williamboman/mason.nvim' }
    use { 'williamboman/mason-lspconfig.nvim' }

    use { 'kkharji/lspsaga.nvim' }

    use { 'jose-elias-alvarez/null-ls.nvim' }
    use { 'folke/lsp-colors.nvim' }
    use {
      'folke/trouble.nvim',
      after = { 'mason.nvim', 'nvim-lspconfig' },
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('trouble').setup({
          --
        })
      end
    }
  end

  -- coc.nvim
  if vim.env.lsp_provider == "coc" then
    use { 'neoclide/coc.nvim', branch = 'release' }
  end

  use { 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } }

  use { 'nvim-telescope/telescope.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

  use { 'kien/rainbow_parentheses.vim' }
  use { 'machakann/vim-sandwich' }
  use { 'cohama/lexima.vim' }
  use { 'monaqa/dial.nvim' }
  use { 'lambdalisue/suda.vim' }

  use { 'rhysd/committia.vim' }
  use { 'lambdalisue/gina.vim' }
  use { 'lewis6991/gitsigns.nvim' }

  use { 'vim-test/vim-test' }

  use { 'lambdalisue/fern.vim' }
  use {
    'lambdalisue/fern-renderer-nerdfont.vim',
    after = { 'fern.vim' },
    requires = { 'lambdalisue/nerdfont.vim' }
  }

  use { 'skanehira/denops-docker.vim', requires = 'vim-denops/denops.vim' }
  use { 'vim-skk/skkeleton', requires = 'vim-denops/denops.vim' }

  use { 'thinca/vim-quickrun' }
  use { 'folke/which-key.nvim' }
end)
