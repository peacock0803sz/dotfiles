local augroup = vim.api.nvim_create_augroup("GinCommitta", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "gitcommit" },
  command = "",
})
