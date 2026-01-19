local ok, util = pcall(require, "lspconfig.util")
if not ok then
  return
end


---@type { [string]: vim.lsp.Config }
local servers = {
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "astro", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    root_dir = util.root_pattern({ "package.json", "node_modules" }),
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
  cssls = { filetypes = { "astro", "css", "scss", "less", "vue" } },
}
return servers
