local loader = require("luasnip.loaders.from_vscode")

function load_snippets()
  for _, file in
    ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/snippets", [[v:val =~ "\.json$"]]))
  do
    print(file)
  end
end
