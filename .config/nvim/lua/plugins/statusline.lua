local function config()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        {
          "diff",
          colored = true,
          diff_color = {
            added = { fg = "#9ece6a" },
            modified = { fg = "#e0af68" },
            removed = { fg = "#db4b4b" },
          },
          symbols = { added = "+", modified = "~", removed = "-" },
        },
      },
      lualine_c = {{ "filename", path = 1 }},
      lualine_x = { "filetype" },
      lualine_z = { "diagnostics" },
      lualine_y = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {{ "filename", path = 1 }},
      lualine_x = { "filetype" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {},
  })
end

local spec = { "nvim-lualine/lualine.nvim", config = config }
return spec
