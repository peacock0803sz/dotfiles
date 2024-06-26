local function config()
  vim.keymap.set("c", "<C-M-C>", function()
    if vim.fn.getcmdtype() == ":" then
      local cmdline = vim.fn.getcmdline()
      vim.fn.histadd(":", cmdline)
      vim.schedule(function()
        vim.cmd("Capture " .. cmdline)
      end)
    end
    return "<C-M-C>"
  end, { expr = true })
end

---@type LazySpec
local spec = { "https://github.com/tyru/capture.vim", config = config, event = "CmdlineEnter" }
return spec
