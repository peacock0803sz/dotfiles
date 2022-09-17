local M = {}

local opts = require("keymaps").opts

-- diagnostics mappings
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '<space>[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', '<space>]d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- buffer mappings
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<space>gD', vim.lsp.buf.declaration, opts)
  -- vim.keymap.set('n', '<space>gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', '<space>gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>fo', vim.lsp.buf.format, bufopts)

  vim.keymap.set('n', '<space>or', function()
    if client.name == "pyright" then
      local params = {
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(0) },
      }
      vim.lsp.buf.execute_command(params)
    else
      vim.lsp.buf.code_action("source.organizeImports")
    end
  end, bufopts)
end
M.on_attach = on_attach

-- specific language server configs
local settings = {
  sumneko_lua = { -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    }
  },
}

-- lspconfig & mason
local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({ function(server)
  local capabilities = require("plugins/configs/nvim_lsp/cmp").capabilities
  local opt = require("cmp_nvim_lsp").update_capabilities(
    capabilities,
    { on_attach = on_attach }-- keymaps
  )
  opt.on_attach = on_attach
  opt.settings = settings[server]
  lspconfig[server].setup(opt)
end })

return M
