local function config()
  vim.g.bookmark_sign = "*"
  vim.g.bookmark_highlight_lines = 1
  vim.g.bookmark_no_default_key_mappings = 1
  vim.g.bookmark_auto_save_file = vim.fn.stdpath("cache") .. "vim-bookmarks"

  vim.keymap.set("n", "mt", "<Cmd>BookmarkToggle<CR>")
  vim.keymap.set("n", "mn", "<Cmd>BookmarkNext<CR>")
  vim.keymap.set("n", "mp", "<Cmd>BookmarkPrev<CR>")
  vim.keymap.set("n", "mr", "<Cmd>BookmarkShowAll<CR>")
  vim.keymap.set("n", "mx", "<Cmd>BookmarkClear<CR>")
end

---@type LazySpec
local spec = { "https://github.com/MattesGroeger/vim-bookmarks", config = config }
return spec
