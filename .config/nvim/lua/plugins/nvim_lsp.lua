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

  table.insert(rtp, "${3rd}/luv/library")
  table.insert(rtp, "${3rd}/luassert/library")

  lspconfig.lua_ls.setup({
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
  lspconfig.astro.setup({})
  lspconfig.cssls.setup({})
  lspconfig.denols.setup({
    filetypes = { "typescript" },
    root_dir = lspconfig.util.root_pattern({ "deno.json", "deno.jsonc", "deps.ts" }),
    single_file_support = true,
    autostart = false,
  })
  lspconfig.dockerls.setup({})
  lspconfig.gopls.setup({})
  lspconfig.lemminx.setup({})
  lspconfig.html.setup({})
  lspconfig.nil_ls.setup({
    root_dir = lspconfig.util.root_pattern({ "flake.nix" }),
    single_file_support = true,
  })
  lspconfig.prismals.setup({})
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
  lspconfig.ruff.setup({})
  lspconfig.sourcekit.setup({})
  lspconfig.tailwindcss.setup({})
  lspconfig.taplo.setup({
    single_file_support = true,
  })
  lspconfig.terraformls.setup({})
  lspconfig.ts_ls.setup({
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    root_dir = lspconfig.util.root_pattern({ "package.json", "node_modules" }),
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vim.env.HOME .. "/.nix-profile/lib/node_modules/@vue/language-server",
          languages = { "javascript", "typescript", "vue" },
        },
      },
    },
    single_file_support = false,
  })
  lspconfig.vimls.setup({})
  lspconfig.volar.setup({
    root_dir = lspconfig.util.root_pattern({ "package.json" }),
    single_file_support = true,
    init_options = {
      typescript = {
        tsdk = vim.env.HOME .. "/.nix-profile/lib/node_modules/typescript/lib",
      },
      vue = {
        hybridMode = false,
      },
    },
  })
  lspconfig.yamlls.setup({
    single_file_support = true,
  })
  setup_keymaps()
end

---@type LazySpec
local spec = {
  "https://github.com/neovim/nvim-lspconfig",
  config = config,
}
return spec
