local function config()
  --
end

---@type LazySpec
local spec = {
  "https://github.com/kuuote/ddu-source-git_status",
  dependencies = { "https://github.com/Shougo/ddu.vim" },
  config = config,
}
return spec
