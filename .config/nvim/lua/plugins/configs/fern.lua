vim.api.nvim_set_var("fern#renderer", "nerdfont")

vim.keymap.set("n", "<space>fe", "<Cmd>Fern -drawer .<CR>", {})

local groupname = "fern_signcolumn"
vim.api.nvim_create_augroup(groupname, { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = groupname,
  pattern = "fern",
  callback = function()
    vim.wo.signcolumn = "no"
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = groupname,
  pattern = "fern",
  callback = function()
    vim.wo.number = false
  end,
})
