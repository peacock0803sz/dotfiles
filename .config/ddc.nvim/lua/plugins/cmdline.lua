local function config()
  vim.fn["cmdline#set_option"]({
    border = "single",
    highlight_window = "None",
    -- highlight_cursor = "TermCursor",
  })
  -- vim.cmd("highlight MsgArea bg=#ffffff fg=#ffffff")
  -- vim.api.nvim_set_hl(0, "MsgArea", { bg = "#ffffff", fg = "#ffffff" })
  vim.api.nvim_create_autocmd({"CmdlineEnter"}, {
    callback = function()
      vim.fn["cmdline#enable"]()
    end
  })
end

---@type LazySpec
local spec = {
  "https://github.com/Shougo/cmdline.vim",
  config = config,
  cond = false,
  dependencies = { "https://github.com/Shougo/ddc.vim" },
}
return spec
