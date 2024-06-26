local function setup_keymaps()
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "<space>[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<space>]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspConfig", {}),
    callback = function(ev)
      local bufopts = { noremap = true, silent = true, buffer = ev.buf }
      -- diagnostics mappings
      vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, bufopts)
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
      vim.keymap.set({ "n", "v" }, "<space>fo", vim.lsp.buf.format, bufopts)

      -- organize imports
      vim.keymap.set("n", "<space>or", function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          local filetype = vim.bo.filetype
        end
      end, bufopts)
    end,
  })
end

local function config()
  -- require("neodev").setup({})

  local rtp = vim.api.nvim_get_runtime_file("", true)
  local lspconfig = require("lspconfig")
  ---@type { [1]: fun(name: string), [string]: fun() }
  local mason_handlers = {
    function(name)
      lspconfig[name].setup({ capabilities = require("cmp_nvim_lsp").default_capabilities() })
    end,
    bashls = function()
      lspconfig.bashls.setup({
        filetypes = { "sh", "bash", "zsh" },
      })
    end,
    lua_ls = function()
      table.insert(rtp, "${3rd}/luv/library")
      table.insert(rtp, "${3rd}/luassert/library")

      lspconfig.lua_ls.setup({
        -- capabilities = capabilities,
        settings = {
          Lua = {
            hint = { enable = true },
            format = { enable = true },
            runtime = {
              version = "LuaJIT",
              checkThirdParty = true,
            },
            diagnostics = {
              globals = { "vim", "wezterm" },
            },
            workspace = {
              library = rtp,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end,
    tsserver = function()
      lspconfig.tsserver.setup({
        root_dir = lspconfig.util.root_pattern({ "package.json", "node_modules" }),
        single_file_support = false,
      })
    end,
    pyright = function()
      lspconfig.pyright.setup({
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
    end,
  }
  lspconfig.denols.setup({
    cmd = { "/Users/peacock/.local/bin/deno", "lsp" },
    filetypes = { "typescript" },
    root_dir = lspconfig.util.root_pattern({ "deno.json", "deno.jsonc", "deps.ts" }),
    single_file_support = true,
  })
  lspconfig.sourcekit.setup({})
  lspconfig.nixd.setup({})
  -- local configs = require("lspconfig.configs")

  -- if not configs.fish_lsp then
  --   configs.fish_lsp = {
  --     default_config = {
  --       name = "fish_lsp",
  --       filetypes = { "fish" },
  --       autostart = true,
  --       single_file_support = true,
  --       cmd = { "fish-lsp", "start" },
  --     },
  --   }
  -- end
  -- lspconfig.fish_lsp.setup({})

  require("mason").setup()
  require("mason-lspconfig").setup({
    handlers = mason_handlers,
  })
  setup_keymaps()
end

---@type LazySpec
local spec = {
  "https://github.com/williamboman/mason-lspconfig.nvim",
  config = config,
  dependencies = {
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    -- "https://github.com/folke/neodev.nvim"
  },
}
return spec
