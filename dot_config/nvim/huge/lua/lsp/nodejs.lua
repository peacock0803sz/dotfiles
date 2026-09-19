---@type { [string]: vim.lsp.Config }
local servers = {
  cssls = { filetypes = { "astro", "css", "scss", "less", "vue" } },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "astro", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    root_dir = function(bufnr)
      return vim.fs.root(bufnr, { "package.json", "node_modules" })
    end,
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vim.env.HOME .. "/.nix-profile/lib/node_modules/@vue/language-server",
          languages = { "vue" },
          configNamespace = "typescript",
        },
      },
      typescript = {
        importModuleSpecifier = "relative",
        inlayHints = {
          parameterNames = {
            enabled = "literals",
            suppressWhenArgumentMatchesName = true,
          },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
    single_file_support = true,
  },
  vtsls = {
    settings = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.env.HOME .. "/.nix-profile/lib/node_modules/@vue/language-server",
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
}
return servers
