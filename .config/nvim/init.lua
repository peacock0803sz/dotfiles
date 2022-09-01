require("options")

require("plugins.list")

-- For emergency, uncomment belows
-- require("plugins.configs.lsp")
-- require("plugins.configs.cmp")

require("keymaps")

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/plugins/configs", [[v:val =~ "\.lua$"]])) do
  require("plugins.configs." .. file:gsub("%.lua$", ""))
end

local lsp_provider = "coc"
-- lsp provider
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/plugins/configs/" .. lsp_provider, [[v:val =~ "\.lua$"]])) do
  require("plugins.configs." .. lsp_provider .. "." .. file:gsub("%.lua$", ""))
end

require("transparents")
require("colorscheme")

require("filetypes")
