local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source(
    "<Space>gi",
    "github_repo_issue",
    { sources = { { name = "github_repo_issue", params = { resume = true } } } }
  )
  map_source(
    "<Space>gp",
    "github_repo_pull",
    { sources = { { name = "github_repo_pull", params = { resume = true } } } }
  )
end

---@type LazySpec
local spec = { "kyoh86/ddu-source-github", dependencies = { "Shougo/ddu.vim" }, config = config }
return spec
