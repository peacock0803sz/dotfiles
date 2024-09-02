local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddc/main.ts"
  vim.fn["ddc#custom#load_config"](path)

  vim.fn["pum#set_option"]({
    max_width = 60,
    preview = true,
    preview_height = 36,
    preview_width = 80,
  })
  vim.keymap.set({ "i", "c" }, "<C-n>", function()
    vim.fn["pum#map#insert_relative"](1)
  end)
  vim.keymap.set({ "i", "c" }, "<C-p>", function()
    vim.fn["pum#map#insert_relative"](-1)
  end)
  vim.keymap.set({ "i", "c" }, "<C-y>", function()
    vim.fn["pum#map#confirm"]()
  end)

  vim.fn["ddc#enable"]()
end

---@type LazySpec
local spec = {
  "https://github.com/Shougo/ddc.vim",
  config = config,
  dependencies = {
    "https://github.com/Shougo/pum.vim",
    "https://github.com/Shougo/ddc-source-around",
    "https://github.com/Shougo/ddc-source-cmdline",
    "https://github.com/Shougo/ddc-source-lsp",
    "https://github.com/Shougo/ddc-source-nvim-lua",
    "https://github.com/Shougo/ddc-source-rg",
    "https://github.com/Shougo/ddc-source-shell-native",
    "https://github.com/Shougo/ddc-ui-pum",
    "https://github.com/tani/ddc-fuzzy"
  },
}
return spec
