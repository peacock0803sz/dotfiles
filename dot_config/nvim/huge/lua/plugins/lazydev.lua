--- @type LazySpec
return {
  "https://github.com/folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "lazy.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
  config = function(_, opts)
    require("lazydev").setup(opts)
  end,
}
