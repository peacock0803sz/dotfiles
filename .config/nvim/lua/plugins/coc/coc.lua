vim.g.coc_global_extensions = {
  "coc-actions",
  "coc-calc",
  "coc-css",
  "coc-deno",
  "coc-diagnostic",
  "coc-docker",
  "coc-eslint",
  "coc-fzf-preview",
  "coc-html",
  "coc-htmldjango",
  "coc-json",
  "coc-pairs",
  "coc-prettier",
  "coc-pyright",
  "coc-rust-analyzer",
  "coc-snippets",
  "coc-sh",
  "coc-stylelint",
  "coc-sh",
  "coc-sumneko-lua",
  "coc-tag",
  "coc-tsserver",
  "coc-vimlsp",
  "coc-word",
  "coc-yaml",
}

-- keymaps
local opts = require("keymaps").opts

vim.keymap.set(
  "i",
  "<slient><expr> <TAB>",
  "coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? '<Tab>' : coc#refresh()",
  opts
)
vim.keymap.set("i", "<slient><expr> <S-TAB>", "coc#pum#visible() ? coc#pum#prev(1) : '<C-h>'", opts)

-- navigate diagnostic
vim.keymap.set("n", "<slient><space>[", "<Plug>(coc-diagnostic-prev)", opts)
vim.keymap.set("n", "<slient><space>]", "<Plug>(coc-diagnostic-next)", opts)

-- code navigation
vim.keymap.set("n", "<space>gd", "<Plug>(coc-definition)", opts)
vim.keymap.set("n", "<space>gy", "<Plug>(coc-type-definition)", opts)
vim.keymap.set("n", "<space>gi", "<Plug>(coc-implementation)", opts)
vim.keymap.set("n", "<space>gr", "<Plug>(coc-reference)", opts)

-- formatting
vim.keymap.set("n", "<space>fo", "<Plug>(coc-format)", opts)
vim.keymap.set(
  "n",
  "<space>or",
  "<Cmd>call CocAction('runCommand', 'editor.action.organizeImport')<CR>",
  opts
)

-- Show documentation
vim.keymap.set("n", "K", function()
  if vim.fn.CocAction("hasProvider", "hover") == true then
    vim.fn.CocActionAsync("doHover")
  else
    vim.fn.feedkeys("K", "in")
  end
end)
