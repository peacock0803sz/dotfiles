local M = {}

--- map ddu#start for keys
function M.map(keys, name, options)
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

return M
