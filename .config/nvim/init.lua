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

if vim.g.neovide then
  vim.o.guifont = "UDEV Gothic NF:h12"
  vim.g.neovide_opacity = 0.9
  vim.g.transparency = 0.9
  vim.g.neovide_input_ime = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_hack = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_short_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_input_macos_option_key_is_meta = "both"

  vim.keymap.set("v", "<D-c>", '"+y')
  vim.keymap.set("n", "<D-v>", '"+P')
  vim.keymap.set("v", "<D-v>", '"+P')
  vim.keymap.set("c", "<D-v>", "<C-R>+")
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli')
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
require("lsp")

vim.api.nvim_create_user_command("PluginList", function()
  local plugins = require("lazy").plugins()
  for _, plugin in ipairs(plugins) do
    vim.print(plugin[1])
  end
end, {})
