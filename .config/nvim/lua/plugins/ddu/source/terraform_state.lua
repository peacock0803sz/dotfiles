local map_source = require("plugins.ddu.map").map_source

local function state_config()
  map_source("<Space>Ts", "terraform_state", { sources = { { name = "terraform_state" } } }, true)
end

---@type LazySpec[]
local spec = {
  {
    "peacock0803sz/ddu-source-terraform_state",
    dev = true,
    dependencies = { "Shougo/ddu.vim" },
    config = state_config,
  },
}
return spec
