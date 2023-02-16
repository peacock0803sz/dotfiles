require("lazy").setup({
  { "folke/neoconf.nvim", cmd = "Neoconf" },

  { "vim-jp/vimdoc-ja" },

  { "nvim-lua/plenary.nvim" },
  { "lambdalisue/nerdfont.vim" },

  { "lambdalisue/guise.vim" },

  { "rmehri01/onenord.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },

  { "nvim-lualine/lualine.nvim" },
  { "akinsho/bufferline.nvim" },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer", dependencies = { "nvim-cmp" } },
    { "hrsh7th/cmp-path", dependencies = { "nvim-cmp" } },
    { "hrsh7th/cmp-cmdline", dependencies = { "nvim-cmp" } },
    { "hrsh7th/cmp-omni", dependencies = { "nvim-cmp" } },
    { "f3fora/cmp-spell", dependencies = { "nvim-cmp" } },

    { "onsails/lspkind.nvim" },

    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "kkharji/lspsaga.nvim" },
    { "SmiteshP/nvim-navic" },

    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
    { "leoluz/nvim-dap-go" },

    { "jose-elias-alvarez/null-ls.nvim" },
    { "folke/lsp-colors.nvim" },
    {
      "folke/trouble.nvim",
      dependencies = { "mason.nvim", "nvim-lspconfig", "nvim-tree/nvim-web-devicons" },
    },
    { "folke/neodev.nvim" },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope-file-browser.nvim" },

  { "lambdalisue/mr.vim" },

  { "kien/rainbow_parentheses.vim" },
  { "machakann/vim-sandwich" },
  { "cohama/lexima.vim" },
  { "monaqa/dial.nvim" },
  { "lambdalisue/suda.vim" },
  { "mattn/emmet-vim" },

  { "rhysd/committia.vim" },
  { "lambdalisue/gina.vim" },
  { "lambdalisue/gin.vim", dependencies = { "vim-denops/denops.vim" } },
  { "lewis6991/gitsigns.nvim" },

  { "vim-test/vim-test" },

  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "github/copilot.vim" },

  { "skanehira/denops-docker.vim", dependencies = "vim-denops/denops.vim" },
  { "vim-skk/skkeleton", dependencies = "vim-denops/denops.vim" },
  { "uga-rosa/cmp-skkeleton" },

  { "tyru/open-browser-github.vim", dependencies = "tyru/open-browser.vim" },

  { "thinca/vim-quickrun", dependencies = "lambdalisue/vim-quickrun-neovim-job" },
  { "folke/which-key.nvim" },
})

