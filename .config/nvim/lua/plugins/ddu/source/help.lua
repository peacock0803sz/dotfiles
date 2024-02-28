local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source("<Space>h", "help", { sources = { { name = "help" } } }, true)

  -- ORIGINAL: https://github.com/yuki-yano/fzf-preview.vim/blob/main/src/connector/vim-help.ts
  -- LICENSE: https://github.com/yuki-yano/fzf-preview.vim/blob/main/LICENSE
  -- Copyright (c) 2018 Yuki Yano
  ---@return string[]
  local function list_plugin_docs()
    ---@type string[]
    local paths = {}
    for _, plugin in ipairs(require("lazy").plugins()) do
      local _docs = vim.fs.find("doc/*.txt", { paths = plugin.dir })
      if _docs then
        table.insert(paths, plugin.dir .. "/doc")
      end
    end
    return paths
  end

  vim.keymap.set("n", "<Space>H", function()
    local paths = list_plugin_docs()
    local args = { name = "help:rg", sources = { { name = "rg", params = { paths = paths } } } }
    vim.fn["ddu#start"](args)
  end, { remap = false, desc = "Start ddu source: help:rg" })
end

---@type LazySpec
local spec = {
  "https://github.com/matsui54/ddu-source-help",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
