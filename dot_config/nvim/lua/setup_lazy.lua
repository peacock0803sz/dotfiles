vim.api.nvim_create_autocmd("User", {
  pattern = "LazyUpdatePre",
  group = vim.api.nvim_create_augroup("lazy-update-pre", {}),
  callback = function()
    local Path = require("plenary.path")
    local config = require("lazy.core.config")
    local to_reset = { "vimdoc-ja" }
    local done = {}
    for _, plugin in ipairs(to_reset) do
      local path = Path:new(config.options.root, plugin).filename
      for _, case in ipairs({
        { type = "reset", cmd = { "git", "reset", "--hard" } },
        { type = "clean", cmd = { "git", "clean", "-df" } },
      }) do
        vim.system(case.cmd, { cwd = path }, function(info)
          table.insert(done, { plugin = plugin, type = case.type, code = info.code })
        end)
      end
    end
    vim.wait(5000, function()
      return #done == #to_reset * 2
    end)
  end,
})

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

vim.api.nvim_create_user_command("PluginList", function()
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    vim.print(plugin[1])
  end
end, {})
