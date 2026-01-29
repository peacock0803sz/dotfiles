local servers = require("lsp.nodejs")
vim.lsp.config("vtsls", servers.vtsls)
vim.lsp.config("cssls", servers.cssls)

-- local ok, util = pcall(require, "lspconfig.util")
-- if ok then
--   return
-- end
-- 
-- ---@type vim.lsp.Config
-- local denols = {
--   filetypes = { "typescript" },
--   root_dir = util.root_pattern({ "deno.json", "deno.jsonc", "deps.ts" }),
--   settings = {
--     deno = {
--       enable = true,
--       suggest = {
--         imports = {
--           hosts = {
--             ["https://deno.land"] = true,
--             ["https://npmjs.com"] = true,
--           },
--         },
--       },
--     },
--   },
--   single_file_support = true,
--   autostart = false,
-- }
-- vim.lsp.config("denols", denols)
