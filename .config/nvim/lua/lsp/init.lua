vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- {{{ Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspConfig", {}),
  callback = function(ev)
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
-- }}}

-- {{{ No Config Servers
vim.lsp.enable({
  "cssls",
  "dockerls",
  "gopls",
  "jsonls",
  "lemminx",
  "html",
  "nixd",
  "prismals",
  "ruff",
  -- "tailwindcss",
  "terraformls",
  "tinymist",
  -- "unocss",
  "vimls",
  "yamlls",
})
-- }}}

-- {{{ Dynamic Loading
-- ref: https://zenn.dev/kawarimidoll/books/6064bf6f193b51/viewer/018161

-- このファイルの存在するディレクトリ
local dirname = vim.fn.stdpath("config") .. "/lua/lsp"

-- 設定したlspを保存する配列
local lsp_names = {}

-- 同一ディレクトリのファイルをループ
for file, ftype in vim.fs.dir(dirname) do
  -- `.lua`で終わるファイルを処理（init.luaは除く）
  if ftype == "file" and vim.endswith(file, ".lua") and file ~= "init.lua" then
    -- 拡張子を除いてlsp名を作る
    local lsp_name = file:sub(1, -5) -- fname without '.lua'
    -- 読み込む
    local ok, result = pcall(require, "lsp." .. lsp_name)
    if ok then
      -- 読み込めた場合はlspを設定
      vim.lsp.config(lsp_name, result)
      table.insert(lsp_names, lsp_name)
    else
      -- 読み込めなかった場合はエラーを表示
      vim.notify("Error loading LSP: " .. lsp_name .. "\n" .. result, vim.log.levels.WARN)
    end
  end
end

-- 読み込めたlspを有効化
vim.lsp.enable(lsp_names)
-- }}}
