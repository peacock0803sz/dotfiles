vim.api.nvim_set_var("fern#renderer", "nerdfont")

vim.api.nvim_set_keymap("n", "<leader>fe", ":<C-u>Fern -drawer .<CR>", {})

local groupname = "fern_signcolumn"
vim.api.nvim_create_augroup(groupname, {clear = true})
vim.api.nvim_create_autocmd({"FileType"}, {
  group=groupname,
  pattern = "fern",
  callback = function() vim.wo.signcolumn = "no" end
})
vim.api.nvim_create_autocmd({"FileType"}, {
  group=groupname,
  pattern = "fern",
  callback = function() vim.wo.number = false end
})
