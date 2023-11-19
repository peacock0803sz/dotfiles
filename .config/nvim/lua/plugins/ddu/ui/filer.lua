local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddu/ui/filer.ts"
  vim.fn["ddu#custom#load_config"](path)

  local group = vim.api.nvim_create_augroup("plug-ddu-ui-filer", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-filer",
    group = group,
    callback = function()
      local helper = require("plugins.ddu.map").map_action

      helper("n", "<C-v>", "itemAction", { name = "open", params = { command = "vsplit" } })
      helper("n", "<C-x>", "itemAction", { name = "open", params = { command = "split" } })
      helper("n", "<C-t>", "itemAction", { name = "open", params = { command = "tabedit" } })
      helper("n", "<CR>", "itemAction", { name = "open" })
      helper("n", "q", "quit")
      helper("n", "<ESC>", "quit")
      helper("n", "+", "chooseAction")

      helper("n", "c", "itemAction", { name = "newFile" })
      helper("n", "d", "itemAction", { name = "delete" })
      helper("n", "m", "itemAction", { name = "move" })
      helper("n", "r", "itemAction", { name = "rename" })
      helper("n", "y", "itemAction", { name = "copy" })
      helper("n", "p", "itemAction", { name = "paste" })
      helper("n", ">", "preview")
      helper("n", "<C-q>", "itemAction", { name = "quickfix" })
      helper("n", "l", "expandItem")
      helper("n", "h", "collapseItem")
    end,
  })
end

---@type LazySpec
local spec = {
  {
    "https://github.com/Shougo/ddu-ui-filer",
    config = config,
    dependencies = "https://github.com/Shougo/ddu.vim",
  },
  { "https://github.com/ryota2357/ddu-column-icon_filename" },
}
return spec
