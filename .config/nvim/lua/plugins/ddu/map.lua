local M = {}

--- map ddu#start for keys
function M.map_source(keys, name, args)
  if type(keys) == "string" then
    keys = { keys }
  end
  for _, key in pairs(keys) do
    local function callback()
      local opts = args or {}
      if type(opts) == "function" then
        opts = opts()
      end
      vim.fn["ddu#start"](opts)
    end
    if name == nil then
      name = args.sources[1].name
    end
    vim.keymap.set("n", key, callback, { remap = false, desc = "Start ddu source: " .. name })
  end
end

function M.map_action(mode, lh, name, opts)
  vim.keymap.set(mode, lh, function()
    local options = opts or vim.empty_dict()
    vim.fn["ddu#ui#do_action"](name, options)
  end, { nowait = true, buffer = true, silent = true, remap = false })
end

return M
