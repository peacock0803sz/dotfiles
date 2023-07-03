-- buffer mappings
local on_attach = function(client, bufnr)
  local opts = require("keymaps").opts
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- diagnostics mappings
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<space>[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<space>]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
  vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>fo", vim.lsp.buf.format, bufopts)

  vim.keymap.set("n", "<space>or", function()
    if client.name == "pyright" then
      local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
      }
      vim.lsp.buf.execute_command(params)
    else
      vim.lsp.buf.code_action("source.organizeImports")
    end
  end, bufopts)
end

-- lspconfig & mason
local function setup_handlers(server, settings)
  local capabilities =
      require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  local opt = require("cmp_nvim_lsp").default_capabilities(capabilities)
  opt.on_attach = on_attach
  opt.settings = settings[server]
  require("lspconfig")[server].setup(opt)
end

local function lspconfig_config()
  local config = {
    --
  }
  for server, settings in pairs(config) do
    require("lspconfig")[server].setup({
      on_attach = on_attach,
      settings = {
        server = settings[server],
      },
    })
  end
end

local function mason_config()
  require("mason-lspconfig").setup()
  require("mason-lspconfig").setup_handlers({
    function(server)
      setup_handlers(server, {
        lua_ls = {
          -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
          Lua = {
            completion = { callSnippet = "Replace" },
            runtime = { version = "LuaJIT" },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
        volar = {
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "json",
          },
        },
        denols = {
          init_options = {
            enable = true,
            lint = true,
            unstable = true,
          },
        },
      })
    end,
  })
end

local spec = {
  { "neovim/nvim-lspconfig",    config = lspconfig_config },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = mason_config,
  },
}
return spec
