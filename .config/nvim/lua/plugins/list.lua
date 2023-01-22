local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use({ "vim-jp/vimdoc-ja" })

  use({ "nvim-lua/plenary.nvim" })
  use({ "lambdalisue/nerdfont.vim" })

  use({ "lambdalisue/guise.vim" })

  -- use({ "rmehri01/onenord.nvim" })
  use({ "catppuccin/nvim", as = "catppuccin" })

  use({ "nvim-lualine/lualine.nvim" })
  use({ "akinsho/bufferline.nvim" })

  if vim.env.lsp_provider == "nvim_lsp" then
    use({ "hrsh7th/nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-buffer", after = { "nvim-cmp" } })
    use({ "hrsh7th/cmp-path", after = { "nvim-cmp" } })
    use({ "hrsh7th/cmp-cmdline", after = { "nvim-cmp" } })
    use({ "hrsh7th/cmp-omni", after = { "nvim-cmp" } })
    use({ "f3fora/cmp-spell", after = { "nvim-cmp" } })

    use({ "onsails/lspkind.nvim" })

    use({ "L3MON4D3/LuaSnip" })
    use({ "saadparwaiz1/cmp_luasnip" })

    use({ "neovim/nvim-lspconfig" })
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })

    use({ "kkharji/lspsaga.nvim" })
    use({ "SmiteshP/nvim-navic" })

    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    use({ "leoluz/nvim-dap-go" })

    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "folke/lsp-colors.nvim" })
    use({
      "folke/trouble.nvim",
      after = { "mason.nvim", "nvim-lspconfig" },
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require("trouble").setup({})
      end,
    })
    use({ "folke/neodev.nvim" })
    -- coc.nvim
  elseif vim.env.lsp_provider == "coc" then
    use({ "neoclide/coc.nvim", branch = "release" })
  end

  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({ "nvim-telescope/telescope.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
  use({ "nvim-telescope/telescope-file-browser.nvim" })

  use({ "lambdalisue/mr.vim" })

  use({ "kien/rainbow_parentheses.vim" })
  use({ "machakann/vim-sandwich" })
  use({ "cohama/lexima.vim" })
  use({ "monaqa/dial.nvim" })
  use({ "lambdalisue/suda.vim" })
  use({ "mattn/emmet-vim" })

  use({ "rhysd/committia.vim" })
  use({ "lambdalisue/gina.vim" })
  use({ "lambdalisue/gin.vim", requires = { "vim-denops/denops.vim" } })
  use({ "lewis6991/gitsigns.nvim" })

  use({ "vim-test/vim-test" })

  use({ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } })
  use({ "github/copilot.vim" })

  use({ "skanehira/denops-docker.vim", requires = "vim-denops/denops.vim" })
  use({ "vim-skk/skkeleton", requires = "vim-denops/denops.vim" })
  use({ "uga-rosa/cmp-skkeleton" })

  use({ "tyru/open-browser-github.vim", requires = "tyru/open-browser.vim" })

  use({ "thinca/vim-quickrun", requires = "lambdalisue/vim-quickrun-neovim-job" })
  use({ "folke/which-key.nvim" })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
