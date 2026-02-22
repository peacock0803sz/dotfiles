local function has_lovot()
  local check_enable = require("utils").check_enable
  local cfg = {
    arpeggio = true,
    nocturne = false,
  }
  local enable = check_enable(cfg)
  local disable_env = vim.env.NVIM_DISABLE_LOVOT_COLORS == nil
  return enable and disable_env
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
    priority = 1001,
    cond = function()
      return not has_lovot()
    end,
  },
  {
    "https://github.com/groove-x/lovot-colors.nvim",
    config = function()
      --- @type lovot_colors.palettes
      local palettes = require("lovot_colors.palettes")

      require("lovot_colors").setup({
        background = "light",
        transparent = true,
        -- italic_comments = false,
        extras = {
          lualine_transparent = { values = { bg = "NONE", fg = "NONE" } },
          lualine_a_normal = { values = { bg = palettes.navy, fg = palettes.white } },
          lualine_b_normal = { values = { bg = "NONE", fg = palettes.navy } },
          lualine_c_normal = { values = { bg = "NONE", fg = palettes.koge } },
          lualine_a_replace = { values = { bg = palettes.red, fg = palettes.white } },
          lualine_b_replace = { values = { bg = "NONE", fg = palettes.red } },
          lualine_c_replace = { values = { bg = "NONE", fg = palettes.red } },
          lualine_a_insert = { values = { bg = palettes.green, fg = palettes.white } },
          lualine_b_insert = { values = { bg = "NONE", fg = palettes.green } },
          lualine_c_insert = { values = { bg = "NONE", fg = palettes.green } },
          lualine_a_command = { values = { bg = palettes.yellow, fg = palettes.white } },
          lualine_b_command = { values = { bg = "NONE", fg = palettes.yellow } },
          lualine_c_command = { values = { bg = "NONE", fg = palettes.yellow } },
          lualine_a_visual = { values = { bg = palettes.violet, fg = palettes.white } },
          lualine_b_visual = { values = { bg = "NONE", fg = palettes.violet } },
          lualine_c_visual = { values = { bg = "NONE", fg = palettes.violet } },
          lualine_a_inactive = { values = { bg = "NONE", fg = palettes.navy } },
          lualine_b_inactive = { values = { bg = "NONE", fg = palettes.navy } },
          lualine_c_inactive = { values = { bg = "NONE", fg = palettes.koge } },
          lualine_a_terminal = { values = { bg = palettes.green, fg = palettes.white } },
          lualine_b_terminal = { values = { bg = "NONE", fg = palettes.green } },
          lualine_c_terminal = { values = { bg = "NONE", fg = palettes.green } },
        },
      })
      vim.cmd.colorscheme("lovot")
    end,
    lazy = false,
    priority = 1000,
    dir = "~/ghq/github.com/groove-x/lovot-colors.nvim",
    cond = has_lovot,
  },
}
return spec
