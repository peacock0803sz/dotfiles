local lsp_provider = "nvim_lsp"
vim.env.lsp_provider = lsp_provider

require("options")

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

require("plugins.list")

-- For emergency, uncomment belows
-- require("plugins.configs.lsp")
-- require("plugins.configs.cmp")

require("keymaps")

for _, file in
  ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/plugins/configs", [[v:val =~ "\.lua$"]]))
do
  require("plugins.configs." .. file:gsub("%.lua$", ""))
end

-- lsp provider
for _, file in
  ipairs(
    vim.fn.readdir(
      vim.fn.stdpath("config") .. "/lua/plugins/configs/" .. lsp_provider,
      [[v:val =~ "\.lua$"]]
    )
  )
do
  require("plugins.configs." .. lsp_provider .. "." .. file:gsub("%.lua$", ""))
end

require("colorscheme")

require("filetypes")
