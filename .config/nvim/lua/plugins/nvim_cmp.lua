local function config()
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
        before = function(_, vim_item)
          return vim_item
        end,
      }),
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-m>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "path" },
      { name = "skkeleton" },
    }, {
      { name = "buffer" },
      { name = "spell" },
    }),
    view = {},
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = "buffer" },
      { name = "spell" },
      { name = "skkeleton" },
    }),
  })

  cmp.setup.filetype("org", {
    sources = cmp.config.sources({
      { name = "orgmode" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = "buffer" },
      { name = "spell" },
      { name = "skkeleton" },
    }),
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
      { name = "skkeleton" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "path" },
      { name = "zsh" },
      { name = "skkeleton" },
    }, {
      { name = "cmdline" },
    }),
  })
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/hrsh7th/nvim-cmp",
    config = config,
    event = "BufEnter",
  },
  {
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/hrsh7th/cmp-buffer",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/hrsh7th/cmp-path",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/tamago324/cmp-zsh",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/hrsh7th/cmp-cmdline",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
    event = "CmdlineEnter",
  },
  {
    "https://github.com/hrsh7th/cmp-omni",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
    event = "InsertEnter",
  },
  {
    "https://github.com/hrsh7th/cmp-nvim-lua",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/f3fora/cmp-spell",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp" },
  },
  {
    "https://github.com/uga-rosa/cmp-skkeleton",
    dependencies = { "https://github.com/hrsh7th/nvim-cmp", "https://github.com/vim-skk/skkeleton" },
  },
  {
    "https://github.com/saadparwaiz1/cmp_luasnip",
    dependencies = { "https://github.com/L3MON4D3/LuaSnip" },
  },
  { "https://github.com/L3MON4D3/LuaSnip", version = "v2.1.*" },
}
return spec
