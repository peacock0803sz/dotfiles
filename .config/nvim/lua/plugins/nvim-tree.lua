local _cmd_height = vim.opt.cmdheight:get()
local _screen_weight = vim.opt.columns:get()
local _screen_height = vim.opt.lines:get() - _cmd_height

local window_weight = math.floor(_screen_weight * 0.95)
local window_height = math.floor(_screen_height * 0.9)

require("nvim-tree").setup({
  view = {
    float = {
      enable = true,
      open_win_config = {
        border = "rounded",
        relative = "editor",
        row = (_screen_height - window_height) / 2 - _cmd_height,
        col = (_screen_weight - window_weight) / 2,
        width = math.floor(window_weight),
        height = math.floor(window_height),
      },
    },
  },
})
