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

---@type LazySpec
local spec = { "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = config }
return spec
