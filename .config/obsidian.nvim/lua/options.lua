-- display options
vim.cmd("syntax enable")
vim.wo.number = false
vim.wo.signcolumn = "no"
vim.o.wrap = true
vim.o.cursorlineopt = "number"
vim.o.laststatus = 2
vim.o.ambiwidth = "single"
vim.o.mouse = "a"
vim.o.termguicolors = true
-- vim.o.colorcolumn = "88,100"

if vim.fn.has("clipboard") == 1 then
  vim.o.clipboard = "unnamedplus,unnamed"
end

-- indent and tab options
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.smarttab = false
vim.o.smartindent = false
vim.o.autoindent = false

-- folding options
vim.opt.foldenable = true
vim.opt.foldmethod = "marker"

-- vim.o.tabline = 2
vim.opt.swapfile = false

-- spelling
-- vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
