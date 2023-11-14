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
local spec = {
  "https://github.com/thinca/vim-quickrun",
  dependencies = "https://github.com/lambdalisue/vim-quickrun-neovim-job",
  config = config,
}
return spec
