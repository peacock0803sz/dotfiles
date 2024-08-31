local function config()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")

  vim.keymap.set("n", "<Space>fb", builtin.buffers, {})

  require("telescope").setup({
    defaults = {
      initial_mode = "normal",
      mappings = {
        n = {
          ["<q>"] = actions.close,
        },
      },
      layout_strategy = "vertical",
      layout_config = {
        height = 0.95,
        width = 0.95,
      },
    },
  })
end

---@type LazySpec
local spec = { "https://github.com/nvim-telescope/telescope.nvim", config = config }
return spec
