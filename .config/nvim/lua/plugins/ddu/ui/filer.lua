local function config()
  local config_dir = vim.fn.stdpath("config")
  local dir = config_dir .. "/ddu/ui/filer.ts"
  vim.fn["ddu#custom#load_config"](dir)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ddu-ff",
    callback = function()
      local function map(mode, lh, rh)
        vim.keymap.set(mode, lh, rh, { nowait = true, buffer = true, silent = true, remap = false })
      end

      map("n", "l", "<Cmd>call ddu#ui#filer#do_action('expandItem')<CR>")
      map("n", "h", "<Cmd>call ddu#ui#filer#do_action('collapseItem')<CR>")
    end,
  })
end

local spec = {
  { "Shougo/ddu-ui-filer",               config = config, dependencies = "Shougo/ddu.vim" },
  { "ryota2357/ddu-column-icon_filename" },
}

return spec
