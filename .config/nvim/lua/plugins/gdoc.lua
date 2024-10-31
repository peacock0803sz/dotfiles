local function config()
  --
end

---@type LazySpec
local spec = {
  "https://github.com/peacock0803sz/denops-gdoc",
  dev = true,
  dependencies = { "https://github.com/vim-denops/denops.vim" },
  config = config,
}
return spec
