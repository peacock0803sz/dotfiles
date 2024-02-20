local function config()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "python",
      "go",
      "hcl",
      "terraform",
      "javascript",
      "typescript",
      "vue",
      "tsx",
      "astro",
      "rust",
      "markdown",
      "css",
      "json",
      "jsonc",
      -- "markdown_inline",
    },
    auto_install = true,
    ignore_install = {},
    sync_install = false,
    highlight = {
      enable = true,
    },
    indent = {
      enable = false,
    },
  })
end

local function init(p)
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.unifieddiff = {
    install_info = {
      url = p.dir,
      files = { "src/parser.c", "src/scanner.c" },
    },
    filetype = "gin-diff",
  }
end

---@type LazySpec[]
local spec = {
  { "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = config },
  {
    "https://github.com/monaqa/tree-sitter-unifieddiff",
    dependencies = "https://github.com/nvim-treesitter/nvim-treesitter",
    init = init,
  },
}
return spec
