local function config()
  require("slidev").setup({
    -- Path to Slidev CLI command (nil for auto-detect)
    slidev_command = nil,
    -- Default port for dev server
    port = 3030,
    -- Enable automatic browser opening
    auto_open_browser = true,
    -- Browser to use (nil for system default)
    browser = nil,
    -- Enable debug logging
    debug = false,
    -- Remote access configuration
    remote = true, -- nil or password string
    -- Theme specification
    theme = nil,
  })
end

---@type LazySpec
local spec = { "https://github.com/mei28/slidev.nvim", config = config }
return spec
