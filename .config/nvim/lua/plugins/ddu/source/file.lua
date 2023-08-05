local function config()
	local map_source = require("plugins.ddu.map").map_source
	map_source("<Space>F", "file", { ui = "filer", sources = { { name = "file" } } })
end

local spec = { "Shougo/ddu-source-file", dependencies = { "Shougo/ddu.vim" }, config = config }

return spec
