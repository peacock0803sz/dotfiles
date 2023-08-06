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

local spec = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = config,
  -- event = "BufRead",
}
return spec
