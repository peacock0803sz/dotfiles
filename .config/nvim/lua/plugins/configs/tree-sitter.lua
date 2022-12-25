require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "python",
    "go",
    "javascript",
    "typescript",
    "vue",
    "tsx",
    "rust",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
})
