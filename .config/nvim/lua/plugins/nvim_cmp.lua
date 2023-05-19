local function setup_bootstrap()
  require("neodev").setup({})
end

local function config_cmp()
  setup_bootstrap()

  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    formatting = {
      -- fields = {'abbr', 'kind', 'menu'},
      format = require("lspkind").cmp_format({
        with_text = true,
        mode = "symbol_text", -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(_, vim_item)
          return vim_item
        end,
      }),
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "path" },
    }, {
      { name = "buffer" },
      { name = "spell" },
      { name = "skkleton" },
    }),
    view = {
      -- entries = "native"
    },
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = "buffer" },
      { name = "spell" },
      { name = "skkleton" },
    }),
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

local spec = {
  {
    "hrsh7th/nvim-cmp",
    config = config_cmp,
    event = "BufEnter",
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer", dependencies = { "hrsh7th/nvim-cmp" } },
  { "hrsh7th/cmp-path", dependencies = { "hrsh7th/nvim-cmp" } },
  {
    "hrsh7th/cmp-cmdline",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "CmdlineEnter",
  },
  {
    "hrsh7th/cmp-omni",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
  },
  { "hrsh7th/cmp-nvim-lua", dependencies = { "hrsh7th/nvim-cmp" } },
  { "f3fora/cmp-spell", dependencies = { "hrsh7th/nvim-cmp" } },
  {
    "uga-rosa/cmp-skkeleton",
    dependencies = { "hrsh7th/nvim-cmp", "vim-skk/skkeleton" },
    event = "InsertEnter",
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = { "L3MON4D3/LuaSnip" },
    event = "InsertEnter",
  },
}

return spec
