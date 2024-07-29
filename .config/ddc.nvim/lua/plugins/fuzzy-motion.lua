local function config()
  vim.keymap.set("n", "S", "<Cmd>FuzzyMotion<CR>")
end

---@type LazySpec
local spec = {
  "https://github.com/yuki-yano/fuzzy-motion.vim",
  dependencies = { "https://github.com/vim-denops/denops.vim" },
  config = config,
}
return spec
