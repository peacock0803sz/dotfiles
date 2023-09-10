local function config()
  vim.keymap.set("n", "<Space>qr", "<Cmd>QuickRun<cr>")
  vim.keymap.set("v", "<Space>qr", "<Cmd>QuickRun<cr>")

  vim.g.quickrun_config = {
    _ = {
      runner = "neovim_job",
      outputter = "quickfix",
    },
  }
end

---@type LazySpec
local spec =
  { "thinca/vim-quickrun", dependencies = "lambdalisue/vim-quickrun-neovim-job", config = config }
return spec
