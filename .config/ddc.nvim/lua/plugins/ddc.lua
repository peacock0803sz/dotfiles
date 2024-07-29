local function config()
  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddc/main.ts"
  vim.fn["ddc#custom#load_config"](path)

  vim.fn["pum#set_option"]({})
  vim.keymap.set({ "i", "c" }, "<C-n>", function()
    vim.fn["pum#map#insert_relative"](1)
  end)
  vim.keymap.set({ "i", "c" }, "<C-p>", function()
    vim.fn["pum#map#insert_relative"](-1)
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
    "https://github.com/Shougo/ddc-ui-pum",
    "https://github.com/tani/ddc-fuzzy"
  },
}
return spec
