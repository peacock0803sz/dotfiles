local function _cond()
  return vim.env.NVIM_COLOR_FALLBACK == nil
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "latte",
        background = {
          light = "latte",
          dark = "mocha",
        },
        styles = {
          comments = {},
        },
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
    lazy = false,
    priority = 1010,
    cond = function()
      return not _cond()
    end,
  },
  {
    "https://github.com/peacock0803sz/peafowl-colors",
    config = function()
      local palettes = require("peafowl_colors.palettes")

      require("peafowl_colors").setup({
        background = "light",
        transparent = true,
        -- italic_comments = false,
        extras = {
          lualine_transparent = { values = { bg = "NONE", fg = "NONE" } },
          lualine_a_normal = { values = { bg = palettes.blue, fg = palettes.white } },
          lualine_b_normal = { values = { bg = "NONE", fg = palettes.blue } },
          lualine_c_normal = { values = { bg = "NONE", fg = palettes.koge } },
          lualine_a_replace = { values = { bg = palettes.scarlet, fg = palettes.white } },
          lualine_b_replace = { values = { bg = "NONE", fg = palettes.scarlet } },
          lualine_c_replace = { values = { bg = "NONE", fg = palettes.scarlet } },
          lualine_a_insert = { values = { bg = palettes.emerald, fg = palettes.white } },
          lualine_b_insert = { values = { bg = "NONE", fg = palettes.emerald } },
          lualine_c_insert = { values = { bg = "NONE", fg = palettes.emerald } },
          lualine_a_command = { values = { bg = palettes.amber, fg = palettes.white } },
          lualine_b_command = { values = { bg = "NONE", fg = palettes.amber } },
          lualine_c_command = { values = { bg = "NONE", fg = palettes.amber } },
          lualine_a_visual = { values = { bg = palettes.amethyst, fg = palettes.white } },
          lualine_b_visual = { values = { bg = "NONE", fg = palettes.amethyst } },
          lualine_c_visual = { values = { bg = "NONE", fg = palettes.amethyst } },
          lualine_a_inactive = { values = { bg = "NONE", fg = palettes.navy } },
          lualine_b_inactive = { values = { bg = "NONE", fg = palettes.navy } },
          lualine_c_inactive = { values = { bg = "NONE", fg = palettes.gray0 } },
          lualine_a_terminal = { values = { bg = palettes.green, fg = palettes.white } },
          lualine_b_terminal = { values = { bg = "NONE", fg = palettes.green } },
          lualine_c_terminal = { values = { bg = "NONE", fg = palettes.green } },
        },
      })
      vim.cmd.colorscheme("peafowl")
    end,
    lazy = false,
    priority = 1000,
    dir = "~/ghq/github.com/peacock0803sz/peafowl-colors/nvim/",
    cond = _cond,
  },
}
return spec
