local function config()
  vim.g["nvim_ghost_server_port"] = 14001

  local group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = false })
  local filetypes = {
    markdown = { "*github.com", "*esa.io" },
  }
  for ft, pattern in pairs(filetypes) do
    vim.api.nvim_create_autocmd(
      "User",
      { group = group, pattern = pattern, command = "set filetype=" .. ft }
    )
  end
end
local cond = require("utils").check_enable({
    nocturne = true,
    arpeggio = true,
    overture = false,
    bassoon = false,
  })

---@type LazySpec
local spec = {
  "https://github.com/subnut/nvim-ghost.nvim",
  config = config(),
  cond = cond and vim.env.NVIM_GHOST,
}
return spec
