local function config()
  local M = require("budouxify.motion")
  vim.keymap.set("n", "W", function()
    local pos = M.find_forward({
      row = vim.api.nvim_win_get_cursor(0)[1],
      col = vim.api.nvim_win_get_cursor(0)[2],
      head = true,
    })
    if pos then
      vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
    end
  end)
  vim.keymap.set("n", "E", function()
    local pos = M.find_forward({
      row = vim.api.nvim_win_get_cursor(0)[1],
      col = vim.api.nvim_win_get_cursor(0)[2],
      head = false,
    })
    if pos then
      vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
    end
  end)
end

local spec = {
  {
    "https://github.com/atusy/budouxify.nvim",
    dependencies = { "https://github.com/atusy/budoux.lua" },
    config = config,
  },
}
return spec
