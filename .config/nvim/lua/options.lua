-- display options
vim.cmd([[ syntax enable ]])
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.o.ambiwidth = "single"
vim.o.mouse = "a"
vim.termguicolors = true

if vim.fn.has("clipboard") == 1 then
  vim.o.clipboard = "unnamedplus,unnamed"
end

-- indent and tab options
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.smartindent = false
vim.o.autoindent = false

vim.o.tabline = 2
