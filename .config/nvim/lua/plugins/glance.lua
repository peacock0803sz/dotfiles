local function config()
  vim.g["glance#markdown_breaks"] = 1
  vim.g["glance#markdown_html"] = 1
  vim.g["glance#stylesheet"] = [[
html, body, #viewer {
  border: none;
  margin: 1rem;
  height: 100%;
  width: 100%;
  font-famiiy: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji !important;
}
  ]]
  -- vim.g["glance#stylesheet"] =
  --   "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.7.0/github-markdown.min.css"
end
---@type LazySpec
local spec = {
  "https://github.com/tani/vim-glance",
  dependencies = { "https://github.com/vim-denops/denops.vim" },
  config = config,
}
return spec
