local function config()
  if vim.env.NVIM_GHOST == nil then
    vim.g["nvim_ghost_autostart"] = 0
  else
    vim.g["nvim_ghost_autostart"] = 1
  end
  vim.g["nvim_ghost_server_port"] = 14001

  local group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = false })
  local filetypes = {
    markdown = { "*github.com", "*backlog.com" },
    html = { "*slack.com", "*zendesk.com" },
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
