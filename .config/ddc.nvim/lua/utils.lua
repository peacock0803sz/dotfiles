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

return M
