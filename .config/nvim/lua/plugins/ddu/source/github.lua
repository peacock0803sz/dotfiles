local function config()
  local map_source = require("plugins.ddu.map").map_source
  map_source(
    "<Space>gi",
    "github_repo_issue",
    { sources = { { name = "github_repo_issue" } } },
    true
  )
  map_source("<Space>gp", "github_repo_pull", { sources = { { name = "github_repo_pull" } } }, true)
end

---@type LazySpec
local spec = { "https://github.com/kyoh86/ddu-source-github", dependencies = { "https://github.com/Shougo/ddu.vim" }, config = config }
return spec
