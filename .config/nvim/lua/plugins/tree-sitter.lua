local treesitter_path = vim.fs.joinpath(vim.fn.stdpath("data"), "/treesitter")

local function config()
  require("nvim-treesitter").setup({ install_dir = treesitter_path })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
    callback = function(ctx)
      -- 必要に応じて`ctx.match`に入っているファイルタイプの値に応じて挙動を制御
      -- `pcall`でエラーを無視することでパーサーやクエリがあるか気にしなくてすむ
      pcall(vim.treesitter.start)
    end,
  })
end

local function build(opts)
  -- nvim-treesitterと同じ場所にパーサーをインストール
  local output = vim.fs.joinpath(opts.parser_path, "unifieddiff.so")
  vim.system({ "tree-sitter", "build", "--output", output }, { cwd = opts.dir }, function() end)
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = config,
    branch = "main",
  },
  {
    "https://github.com/monaqa/tree-sitter-unifieddiff",
    dependencies = "https://github.com/nvim-treesitter/nvim-treesitter",
    build = build,
    cond = false,
  },
}
return spec
