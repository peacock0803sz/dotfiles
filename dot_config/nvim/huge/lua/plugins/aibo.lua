local function config()
  require("aibo").setup({
    --
  })
end

local spec = {
  "https://github.com/lambdalisue/nvim-aibo",
  config = config,
}
return spec
