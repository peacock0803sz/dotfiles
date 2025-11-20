local function config()
  vim.g["nvim_ghost_server_port"] = 14001

  local group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = false })
  local filetypes = {
    markdown = { "*github.com", "*esa.io" }
  }
  for ft, pattern in pairs(filetypes) do
    vim.api.nvim_create_autocmd(
      "User",
      { group = group, pattern = pattern, command = "set filetype=" .. ft }
    )
  end
end

---@type LazySpec
local spec = { "https://github.com/subnut/nvim-ghost.nvim", config = config() }
return spec
