local function config()
	local helper = require("plugins.ddu.map")
	helper.map_source("<Space>fg", "rg", { sources = { { name = "rg" } } })
end

local spec = { "shun/ddu-source-rg", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
