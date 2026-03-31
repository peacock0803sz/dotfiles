vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

if vim.env.NVIM_LSP_DEBUG == "1" then
  vim.lsp.log.set_level(vim.log.levels.TRACE)
end

-- Set buftype=nofile on ddu buffers early (before bufload triggers BufNewFile/filetype detection)
vim.api.nvim_create_autocmd("BufNew", {
  group = vim.api.nvim_create_augroup("LspGuard", { clear = true }),
  callback = function(args)
    if vim.api.nvim_buf_get_name(args.buf):find("^ddu%-") then
      vim.bo[args.buf].buftype = "nofile"
    end
  end,
})

-- {{{ Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspConfig", {}),
  callback = function(ev)
    -- Detach LSP from ddu-* preview buffers
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if bufname:find("^ddu%-") then
      vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
      return
    end

    local bufopts = { noremap = true, silent = true, buffer = ev.buf }
    -- diagnostics mappings
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
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
