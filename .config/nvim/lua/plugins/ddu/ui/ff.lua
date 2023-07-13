local function config()
  -- local group = vim.api.nvim_create_augroup("plug-ddu-ui-ff", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- group = group,
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

      nmap("/", '<Cmd>call ddu#ui#do_action("openFilterWindow")<CR>')
      nmap("<ESC>", '<Cmd>call ddu#ui#do_action("quit")<CR>')
      nmap("<CR>", '<Cmd>call ddu#ui#do_action("itemAction")<CR>')
      nmap(">", '<Cmd>call ddu#ui#do_action("expandItem")<CR>')
      nmap("+", '<Cmd>call ddu#ui#do_action("chooseAction")<CR>')
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    -- group = group,
    pattern = "ddu-ff-filter",
    callback = function()
      vim.opt_local.cursorline = false
      local o = { buffer = true, silent = true, remap = true }

      vim.keymap.set("n", "<ESC>", '<Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>', o)
      vim.keymap.set("i", "<CR>", '<Cmd>call ddu#ui#do_action("leaveFilterWindow")<cr>', o)
      vim.keymap.set("i", "<bs>", function()
        return vim.fn.col(".") <= 1 and "" or "<bs>"
      end, o)
    end,
  })
end

local spec = {
  {
    "Shougo/ddu-ui-ff",
    config = config,
    dependencies = "Shougo/ddu.vim",
  },
}

return spec
