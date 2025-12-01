local util = require("lspconfig.util")

---@type vim.lsp.Config
local config = {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_dir = util.root_pattern({ "package.json", "node_modules" }),
  settings = {
    typescript = {
      importModuleSpecifier = "relative",
      inlayHints = {
        parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    vtsls = {
      settings = { typescript = { tsserver = { maxTsServerMemory = 2048 } } },
      tsserver = {
        globalPlugins = {
          name = "@vue/typescript-plugin",
          location = vim.env.HOME .. "/.nix-profile/lib/node_modules/@vue/language-server",
          languages = { "vue" },
          configNamespace = "typescript",
        },
      },
    },
  },
  single_file_support = true,
}
return config
