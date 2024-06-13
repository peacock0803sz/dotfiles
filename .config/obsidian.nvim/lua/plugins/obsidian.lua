local function config()
  require("obsidian").setup({
    workspaces = {
      {
        name = "peacock0803sz",
        path = "~/Documents/obsidian/peacock0803sz/",
      },
      {
        name = "work",
        path = "~/Documents/obsidian/work/",
      },
    },
  })

  vim.keymap.set("n", "<Space>ff", "<Cmd>ObsidianQuickSwitch<CR>", {})
  vim.keymap.set("n", "<Space>fg", "<Cmd>ObsidiianSearch<CR>", {})
end

---@type LazySpec
local spec = {
  "https://github.com/epwalsh/obsidian.nvim",
  dependencies = {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
  },
  config = config,
}
return spec
