local function config()
  local group = vim.api.nvim_create_augroup("plug-ddu-ui-ff", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "ddu-ff",
    callback = function()
      local function map(mode, lh, rh)
        vim.keymap.set(mode, lh, rh, { nowait = true, buffer = true, silent = true, remap = false })
      end

      local function item_action(name, params, stopinsert)
        if stopinsert then
          vim.cmd.stopinsert()
          vim.schedule(function()
            vim.fn["ddu#ui#do_action"]("itemAction", { name = name, params = params })
          end)
        else
          vim.fn["ddu#ui#do_action"]("itemAction", { name = name, params = params })
        end
      end
      map("n", "<C-v>", item_action("open", { command = "vsplit" }, true))
    end,
  })
end

local spec = { "Shougo/ddu-kind-file", config = config, dependencies = { "Shougo/ddu.vim" } }

return spec
