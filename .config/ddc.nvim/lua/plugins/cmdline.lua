local function config()
  vim.fn["cmdline#set_option"]({
    border = "single",
    row = 1,
  })
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
  dependencies = { "https://github.com/Shougo/ddc.vim" },
}
return spec
