local function config()
  local dir = vim.fn.stdpath("config") .. "/snippets/"
  for name, _ in vim.fs.dir(dir) do
    vim.fn["denippet#load"](dir .. name)
  end
end

---@type LazySpec
local spec = {
  "https://github.com/uga-rosa/denippet.vim",
  dependencies = { "denops.vim" },
  config = config
}
return spec
