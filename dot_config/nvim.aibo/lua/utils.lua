local M = {}

function M.join_table(...)
  local result = {}
  for _, table in ipairs({ ... }) do
    for key, value in ipairs(table) do
      if type(key) == "string" then
        result[key] = value
      elseif type(key) == "number" then
        result[#result + 1] = value
      else
        error()
      end
    end
  end
  return result
end

---@param cfg table<string, boolean>
function M.check_enable(cfg)
  ---@type hostname string
  local hostname = vim.loop.os_gethostname()

  for k, v in pairs(cfg) do
    if hostname == k then
      return v
    end
  end
end

return M
