local function config()
  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
      augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
      augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
    },
  })

  local map = require("dial.map")
  vim.keymap.set("n", "<C-a>", map.inc_normal(), { noremap = true })
  vim.keymap.set("n", "<C-x>", map.dec_normal(), { noremap = true })
  vim.keymap.set("v", "<C-a>", map.inc_visual(), { noremap = true })
  vim.keymap.set("v", "<C-x>", map.dec_visual(), { noremap = true })
  vim.keymap.set("v", "g<C-a>", map.inc_gvisual(), { noremap = true })
  vim.keymap.set("v", "g<C-x>", map.dec_gvisual(), { noremap = true })
end

local spec = { "monaqa/dial.nvim", config = config, event = "BufEnter" }
return spec
