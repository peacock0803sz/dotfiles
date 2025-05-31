---@type vim.lsp.Config
local config = {
  single_file_support = true,
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { "*" },
      },
    },
  },
}
return config
