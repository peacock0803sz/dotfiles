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
      lualine_b = {},
      lualine_c = { { "filename", path = 4 } },
      lualine_x = { "searchcount" },
      lualine_y = { "filesize" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {},
  })
end

---@type LazySpec
local spec = { "nvim-lualine/lualine.nvim", config = config }
return spec
