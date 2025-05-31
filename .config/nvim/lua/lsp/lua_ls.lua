local rtp = vim.api.nvim_get_runtime_file("", true)

table.insert(rtp, "${3rd}/luv/library")
table.insert(rtp, "${3rd}/luassert/library")

---@type vim.lsp.Config
local config = {
  settings = {
    Lua = {
      hint = { enable = true },
      format = { enable = true },
      runtime = {
        version = "LuaJIT",
        checkThirdParty = true,
      },
      diagnostics = {
        globals = { "vim", "wezterm" },
      },
      workspace = {
        library = rtp,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
return config
