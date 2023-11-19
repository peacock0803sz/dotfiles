local function config()
  vim.keymap.set("i", "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
  vim.keymap.set("i", "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyPluginPost:insx",
    callback = function()
      vim.keymap.set("i", "<CR>", function()
        local info = vim.fn["pum#complete_info"]()
        if info.pum_visible then
          if info.selected >= 0 then
            return vim.fn["pum#map#confirm"]()
          else
            return vim.fn["ddc#map#insert_item"](0)
          end
        elseif vim.fn["denippet#expandable"]() == false then
          return vim.keycode("<Plug>(denippet-expand)")
        else
          return vim.fn["insx#expand"]("<CR>")
        end
      end)
    end,
  })
  vim.fn["pum#set_option"]({
    highlight_matches = "Normal",
    max_horizontal_items = 5,
    scrollbar_char = "┃",
  })

  local config_dir = vim.fn.stdpath("config")
  local path = config_dir .. "/ts/ddc.ts"
  vim.fn["ddc#custom#load_config"](path)
  vim.fn["ddc#enable"]()
  require("ddc_previewer_floating").setup({
    ui = "pum",
  })
  require("ddc_previewer_floating").enable()
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/Shougo/ddc.vim",
    dependencies = {
      "https://github.com/vim-denops/denops.vim",
      "https://github.com/Shougo/pum.vim",
      "https://github.com/Shougo/ddc-ui-pum",
      "https://github.com/uga-rosa/denippet.vim",
    },
    config = config,
  },
  { "https://github.com/Shougo/ddc-source-around" },
  { "https://github.com/Shougo/ddc-source-shell-native" },
  { "https://github.com/Shougo/ddc-source-shell" },
  { "https://github.com/Shougo/ddc-source-input" },
  { "https://github.com/Shougo/ddc-source-rg" },
  { "https://github.com/Shougo/ddc-source-line" },
  { "https://github.com/Shougo/ddc-source-cmdline" },
  { "https://github.com/Shougo/ddc-source-cmdline-history" },
  { "https://github.com/Shougo/ddc-source-omni" },
  { "https://github.com/matsui54/ddc-buffer" },
  { "https://github.com/LumaKernel/ddc-source-file" },
  { "https://github.com/Shougo/ddc-filter-matcher_head" },
  { "https://github.com/Shougo/ddc-filter-matcher_length" },
  { "https://github.com/Shougo/ddc-filter-matcher_prefix" },
  { "https://github.com/Shougo/ddc-filter-matcher_vimregexp" },
  { "https://github.com/Shougo/ddc-filter-sorter_rank" },
  { "https://github.com/Shougo/ddc-filter-sorter_head" },
  { "https://github.com/Shougo/ddc-filter-converter_remove_overlap" },
  { "https://github.com/Shougo/ddc-filter-converter_truncate_abbr" },
  { "https://github.com/Shougo/neco-vim" },
  { "https://github.com/uga-rosa/ddc-previewer-floating" },
}
return spec
