-- display options
vim.cmd("syntax enable")
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.o.wrap = true
vim.o.cursorlineopt = "number"
vim.o.laststatus = 2
vim.o.ambiwidth = "single"
vim.o.mouse = "a"
vim.o.termguicolors = true
-- vim.o.colorcolumn = "88,100"

-- Clipboard configuration
-- SSH環境でlemonadeが利用可能な場合はlemonadeを使用
local ssh_client = vim.env.SSH_CLIENT
if ssh_client and vim.fn.executable("lemonade") == 1 then
  -- `$SSH_CLIENT` からリモートホストのIPを抽出 (例: "192.168.1.100 54321 22" -> "192.168.1.100")
  local remote_host = ssh_client:match("^(%S+)")
  if remote_host then
    vim.g.clipboard = {
      name = "lemonade",
      copy = {
        ["+"] = { "lemonade", "--host", remote_host, "copy" },
        ["*"] = { "lemonade", "--host", remote_host, "copy" },
      },
      paste = {
        ["+"] = { "lemonade", "--host", remote_host, "paste" },
        ["*"] = { "lemonade", "--host", remote_host, "paste" },
      },
      cache_enabled = false,
    }
    -- プロバイダーが既にロードされていたらリロード
    if vim.g.loaded_clipboard_provider then
      vim.g.loaded_clipboard_provider = nil
      vim.cmd("runtime autoload/provider/clipboard.vim")
    end
    vim.o.clipboard = "unnamed"
  end
elseif vim.fn.has("clipboard") == 1 then
  -- ローカル環境ではシステムクリップボードを使用
  vim.o.clipboard = "unnamed"
end

-- indent and tab options
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.smarttab = false
vim.o.smartindent = false
vim.o.autoindent = false

-- folding options
vim.opt.foldenable = true
vim.opt.foldmethod = "marker"

-- vim.o.tabline = 2
vim.opt.swapfile = false

-- spelling
-- vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
