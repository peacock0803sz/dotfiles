local function config()
  local loader = require("luasnip.loaders.from_vscode")

  function load_snippets()
    for _, file in
      ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/snippets", [[v:val =~ "\.json$"]]))
    do
      loader.load(file)
    end
  end
end

---@type LazySpec
local spec = { "https://github.com/L3MON4D3/LuaSnip", cofing = config }
return spec
