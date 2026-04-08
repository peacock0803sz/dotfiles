---@type vim.lsp.Config
local lua_ls = {
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true },
      hover = { enable = true },
      format = { enable = true },
      completion = { autoRequire = false },
      runtime = { version = "LuaJIT" },
      workspace = {
        library = { vim.env.VIMRUNTIME .. "/lua" },
      },
      telemetry = { enable = false },
    },
  },
}
vim.lsp.config("lua_ls", lua_ls)

vim.lsp.enable("lua_ls")
