local M = {}

--- map ddu#start for keys
function M.map_source(keys, name, options)
  if type(keys) == "string" then
    keys = { keys }
  end
  for _, key in pairs(keys) do
    vim.keymap.set("n", key, function()
      local opts = options or {}
      if type(opts) == "function" then
        opts = opts()
      end
      opts.name = name
      vim.fn["ddu#start"](opts)
    end, { remap = false, desc = "Start ddu source: " .. name })
  end
end

function M.map_action(mode, lh, name, opts)
  vim.keymap.set(mode, lh, function()
    local options = opts or vim.empty_dict()
    vim.fn["ddu#ui#do_action"](name, options)
  end, { nowait = true, buffer = true, silent = true, remap = false })
end

return M
