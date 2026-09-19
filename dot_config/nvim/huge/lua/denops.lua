if vim.env.DENOPS_DENO_PATH then
  vim.g["denops#deno"] = vim.env.DENOPS_DENO_PATH
end

if vim.env.DENOPS_SERVER_ADDR then
  vim.g.denops_server_addr = vim.env.DENOPS_SERVER_ADDR
end

if vim.env.DENOPS_DEBUG then
  vim.g["denops#debug"] = true
  vim.g["denops#trace"] = true
end

vim.api.nvim_create_user_command("DenopsReloadCache", function()
  vim.fn["denops#cache#update"]({ reload = true })
end, { bang = true })
