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
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "filetype" },
			lualine_y = {
				{
					"diagnostics",
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = { fg = "#db4b4b" },
						warn = { fg = "#e0af68" },
						info = { fg = "#20c9c7" },
						hint = { fg = "#9ece6a" },
					},
				},
			},
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "filetype" },
			lualine_y = {},
			lualine_z = {},
		},
		extensions = {},
	})
end

local spec = { "nvim-lualine/lualine.nvim", config = config }
return spec
