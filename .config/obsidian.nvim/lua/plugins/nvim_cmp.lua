local function config()
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
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
      { name = "luasnip" }, -- For luasnip users.
      { name = "path" },
      { name = "skkeleton" },
    }, {
      { name = "buffer" },
      { name = "spell" },
    }),
    view = {},
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
      { name = "path" },
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
  },
  {
    "https://github.com/hrsh7th/cmp-path",
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
