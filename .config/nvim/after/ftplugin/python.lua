vim.lsp.config("pyright", {
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
})

vim.lsp.enable({"pyright", "ruff"})
