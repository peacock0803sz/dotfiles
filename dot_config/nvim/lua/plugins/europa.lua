local function config()
  vim.g.europa_image_backend = "sixel" -- 'auto', 'sixel', 'kitty', 'iterm2_osc1337'
  vim.g.europa_mime_priority = { "image/png", "image/jpeg", "text/html", "text/plain" }
  vim.g.europa_max_output_lines = 100
  vim.g.europa_cell_border_chars = { "╭", "─", "╮", "╰", "╯" }
  vim.g.europa_lazy_padding = 10
end

---@type LazySpec
local spec = { "https://github.com/peacock0803sz/Europa.vim", config = config, dev = true }
return spec
