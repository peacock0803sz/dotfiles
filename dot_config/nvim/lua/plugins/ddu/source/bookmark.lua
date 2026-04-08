local function config()
  local helper = require("plugins.ddu.map")
  helper.map_source("<Space>b", "bookmark", { sources = { { name = "vim-bookmark" } } })
end

---@type LazySpec
local spec = {
  "https://github.com/nekowasabi/ddu-source-vim-bookmark",
  dependencies = {
    "https://github.com/Shougo/ddu.vim",
    "https://github.com/MattesGroeger/vim-bookmarks",
  },
  config = config,
}
return spec
