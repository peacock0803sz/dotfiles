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
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
})
