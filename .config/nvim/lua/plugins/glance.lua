local function config()
  vim.g["glance#server_open"] = 0
  vim.g["glance#server_silent"] = 1
  vim.g["glance#markdown_breaks"] = 1
  vim.g["glance#markdown_linkify"] = 1
  vim.g["glance#markdown_html"] = 1
  vim.g["glance#stylesheet"] = [[
html, body, #viewer {
  border: none;
  font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji;
}
pre > code {
  text-wrap: wrap;
}
  ]]
  -- vim.g["glance#stylesheet"] =
  --   "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.7.0/github-markdown.min.css"
end
---@type LazySpec
local spec = {
  "https://github.com/peacock0803sz/vim-glance",
  dependencies = { "https://github.com/vim-denops/denops.vim" },
  dev = true,
  config = config,
}
return spec
