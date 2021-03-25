-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod

local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' },
    mappings = {
      i = {
        ["<c-x>"] = false,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  }
}
  
-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
