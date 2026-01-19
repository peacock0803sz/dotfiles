local rtp = vim.api.nvim_get_runtime_file("*.lua", true)

table.insert(rtp, "${3rd}/luv/library")
table.insert(rtp, "${3rd}/luassert/library")

---@type vim.lsp.Config
local lua_ls = {
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true },
      hover = { enable = true },
      format = { enable = true },
      runtime = { version = "LuaJIT", checkThirdParty = true, path = { "?.lua" } },
      diagnostics = { globals = { "vim", "wezterm" } },
      workspace = { library = rtp },
      telemetry = { enable = false },
    },
  },
}
vim.lsp.config("lua_ls", lua_ls)

vim.lsp.enable("lua_ls")
