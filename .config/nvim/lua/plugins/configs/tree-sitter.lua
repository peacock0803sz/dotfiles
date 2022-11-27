require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "javascript", "vue", "rust" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
})
