require("options")

if vim.env.DENOPS_DENO_PATH then
  vim.g["denops#deno"] = vim.env.DENOPS_DENO_PATH
end

if vim.env.DENOPS_SERVER_ADDR then
  vim.g.denops_server_addr = vim.env.DENOPS_SERVER_ADDR
end

if vim.env.DENOPS_DEBUG then
  vim.g["denops#debug"] = true
  vim.g["denops#trace"] = true
end

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
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
local opts = { dev = { path = "~/ghq/github.com/peacock0803sz" } }
require("lazy").setup("plugins", opts)

require("keymaps")

vim.api.nvim_create_user_command("PluginList", function()
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    vim.print(plugin[1])
  end
end, {})
