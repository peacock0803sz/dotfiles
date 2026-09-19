local function config(p)
  vim.keymap.set("i", "<C-\\>", "<Plug>(skkeleton-toggle)", {})
  vim.keymap.set("c", "<C-\\>", "<Plug>(skkeleton-toggle)", {})

  ---@type string
  local lazy_root = require("lazy.core.config").options.root
  local dictdir = lazy_root .. "/dict"
  local user_dict = ""
  if vim.fn.has("macunix") then
    user_dict =
      "~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/skk-jisyo.utf8"
  end
  vim.fn["skkeleton#config"]({
    userDictionary = user_dict,
    eggLikeNewline = true,
    selectCandidateKeys = "1234567",
    showCandidatesCount = 1,
    globalDictionaries = {
      vim.fs.joinpath(dictdir, "SKK-JISYO.L"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.assoc"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.emoji"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.edict"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.edict2"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.fullname"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.geo"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.hukugougo"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.mazegaki"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.propernoun"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.station"),
    },
  })
end

local function build(p)
  local plugin_dir = p.dir
  local macskk_dir = vim.env.HOME
    .. "/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/"
  for fname, _ in vim.fs.dir(plugin_dir) do
    if fname:match("SKK%-JISYO") then
      vim.uv.fs_copyfile(vim.fs.joinpath(plugin_dir, fname), vim.fs.joinpath(macskk_dir, fname))
    end
  end
end

-- @type LazySpec[]
local spec = {
  {
    "https://github.com/vim-skk/skkeleton",
    dependencies = { "https://github.com/vim-denops/denops.vim", "https://github.com/skk-dev/dict" },
    config = config,
  },
  { "https://github.com/skk-dev/dict", build = build },
  {
    "https://github.com/delphinus/skkeleton_indicator.nvim",
    after = "skkeleton",
    config = function()
      require("skkeleton_indicator").setup({})
    end,
  },
}
return spec
