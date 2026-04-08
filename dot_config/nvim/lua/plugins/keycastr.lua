local cond = vim.env.NVIM_KEYCASTR == "1"

local function config()
  local keycastr = require("keycastr")
  keycastr.config.set({
    position = "SE",
    win_config = { border = "rounded" },
  })
  keycastr.enable()
end

---@type LazySpec
local spec = { "https://github.com/4513ECHO/nvim-keycastr", config = config, cond = cond }
return spec
