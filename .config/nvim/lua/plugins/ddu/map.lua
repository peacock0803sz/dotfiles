local M = {}

---@param keys string|string[]
---@param name string|nil
---@param args table
---@param resume boolean|nil
--- map ddu#start for keys
function M.map_source(keys, name, args, resume)
  if type(keys) == "string" then
    keys = { keys }
  end
  for _, key in pairs(keys) do
    local function callback()
      if args == nil then
        args = vim.empty_dict()
      end
      -- if resume is true, args.params.resume will be set to true
      if resume ~= nil then
        args.resume = resume
      end

      vim.fn["ddu#start"](args)
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
