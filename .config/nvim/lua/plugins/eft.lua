local function config()
  local function map(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true })
    vim.api.nvim_set_keymap("x", lhs, rhs, { noremap = true })
    vim.api.nvim_set_keymap("o", lhs, rhs, { noremap = true })
  end

  map(";", "<Plug>(eft-repeat)")
  map("f", "<Plug>(eft-f)")
  map("F", "<Plug>(eft-F)")
  map("t", "<Plug>(eft-t)")
  map("T", "<Plug>(eft-T)")
end

---@type LazySpec
local spec = { "hrsh7th/vim-eft", config = config }
return spec
