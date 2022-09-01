vim.g.coc_global_extensions = {
  'coc-actions',
  'coc-calc',
  'coc-css',
  'coc-deno',
  'coc-diagnostic',
  'coc-docker',
  'coc-eslint',
  'coc-fzf-preview',
  'coc-html',
  'coc-htmldjango',
  'coc-json',
  'coc-pairs',
  'coc-prettier',
  'coc-pyright',
  'coc-rust-analyzer',
  'coc-snippets',
  'coc-sh',
  'coc-stylelint',
  'coc-sh',
  'coc-sumneko-lua',
  'coc-tag',
  'coc-tsserver',
  'coc-vimlsp',
  'coc-word',
  'coc-yaml'
}

-- keymaps
local opts = require("keymaps").opts

vim.api.nvim_set_keymap("i", "<slient><expr> <TAB>", "coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? '<Tab>' : coc#refresh()", opts)
vim.api.nvim_set_keymap("i", "<slient><expr> <S-TAB>", "coc#pum#visible() ? coc#pum#prev(1) : '<C-h>'", opts)

-- navigate diagnostic
vim.api.nvim_set_keymap("n", "<slient><space>[", "<Plug>(coc-diagnostic-prev)", opts)
vim.api.nvim_set_keymap("n", "<slient><space>]", "<Plug>(coc-diagnostic-next)", opts)

-- code navigation
vim.api.nvim_set_keymap("n", "gd", "<nop>", opts)
vim.api.nvim_set_keymap("n", "gy", "<nop>", opts)
vim.api.nvim_set_keymap("n", "gi", "<nop>", opts)
vim.api.nvim_set_keymap("n", "gr", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<space>gd", "<Plug>(coc-definition)", opts)
vim.api.nvim_set_keymap("n", "<space>gy", "<Plug>(coc-type-definition)", opts)
vim.api.nvim_set_keymap("n", "<space>gi", "<Plug>(coc-implementation)", opts)
vim.api.nvim_set_keymap("n", "<space>gr", "<Plug>(coc-reference)", opts)

-- Show documentation
vim.api.nvim_set_keymap("n", "<slient>K", "<nop>", {})
vim.api.nvim_set_keymap("n", "<slient>K", ":lua ShowDoc()", {})
function ShowDoc()
  if vim.fn.CocAction("hasProvider", "hover") then
    vim.fn.CocActionSync("doHover")
  else
    vim.fn.feedkeys("K", "in")
  end
end

