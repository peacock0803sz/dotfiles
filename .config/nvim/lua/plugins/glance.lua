local function config()
  vim.g["glance#server_open"] = false
  vim.g["glance#markdown_plugins"] = {"https://esm.sh/remark-gfm@4"}
  -- vim.g["glance#markdown_html"] = true
  -- vim.g["glance#stylesheet"] =
  --   "@import url('https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown.css')"
end

---@type LazySpec[]
local spec = {
  "https://github.com/tani/vim-glance",
  config = config,
  dependencies = "https://github.com/vim-denops/denops.vim",
}
return spec
