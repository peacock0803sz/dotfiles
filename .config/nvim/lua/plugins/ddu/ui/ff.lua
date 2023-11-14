local function config()
  local config_dir = vim.fn.stdpath("config")
  local dir = config_dir .. "/ddu/ui/ff.ts"

  vim.fn["ddu#custom#load_config"](dir)
  local group = vim.api.nvim_create_augroup("plug-ddu-ui-ff", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "ddu-ff",
    callback = function()
      local nmap = function(lh, rh)
        vim.keymap.set("n", lh, rh, { nowait = true, buffer = true, silent = true, remap = false })
      end
      -- nmap("<c-w>", "<nop>")
      nmap("<c-o>", "<nop>")
      nmap("<c-j>", "<nop>")
      -- nmap(":", "<nop>")
      -- nmap("q", "<nop>")
      nmap("m", "<nop>")
      nmap("t", "<nop>")
      -- nmap(";", ":")

      local map_action = require("plugins.ddu.map").map_action
      map_action("n", "<C-v>", "itemAction", { name = "open", params = { command = "vsplit" } })
      map_action("n", "<C-x>", "itemAction", { name = "open", params = { command = "split" } })
      map_action("n", "<C-t>", "itemAction", { name = "open", params = { command = "tabedit" } })
      vim.keymap.set("n", "<C-q>", function()
        vim.fn["ddu#ui#do_action"]("toggleAllItems")
        vim.fn["ddu#ui#do_action"]("itemAction", { name = "quickfix" })
      end)
      map_action("n", "/", "openFilterWindow")
      map_action("n", "q", "quit")
      map_action("n", "q", "quit")
      map_action("n", "<CR>", "itemAction")
      map_action("n", "+", "chooseAction")
      map_action("n", "l", "expandItem")
      map_action("n", "h", "collapseItem")
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    -- group = group,
    pattern = "ddu-ff-filter",
    callback = function()
      vim.opt_local.cursorline = false
      local o = { buffer = true, silent = true }

      vim.keymap.set("n", "q", '<Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>', o)
      vim.keymap.set("i", "<CR>", '<ESC><Cmd>call ddu#ui#do_action("leaveFilterWindow")<cr>', o)
      vim.keymap.set("i", "<bs>", function()
        return vim.fn.col(".") <= 1 and "" or "<bs>"
      end, { buffer = true, silent = true, expr = true })
    end,
  })
end

---@type LazySpec
local spec = {
  {
    "https://github.com/Shougo/ddu-ui-ff",
    config = config,
    dependencies = "https://github.com/Shougo/ddu.vim",
  },
}
return spec
