local function config()
	local map_source = require("plugins.ddu.map").map_source
	map_source("<Space>h", "help", { sources = { { name = "help" } } })
end

local spec = { "uga-rosa/ddu-source-help", dependencies = { "Shougo/ddu.vim" }, config = config }
return spec
