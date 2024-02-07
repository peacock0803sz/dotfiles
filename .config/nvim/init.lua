require("options")

if vim.env.DENOPS_DEBUG then
  vim.g["denops#debug"] = true
  vim.g["denops#trace"] = true
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local opts = { dev = { path = "~/ghq/github.com/peacock0803sz" } }
require("lazy").setup("plugins", opts)

require("keymaps")
require("autocommands")

vim.api.nvim_create_user_command("PluginList", function()
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    vim.print(plugin[1])
  end
end, {})
