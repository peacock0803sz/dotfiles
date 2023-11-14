local function config(p)
  vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)", {})
  vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-toggle)", {})

  vim.fn["skkeleton#config"]({
    eggLikeNewline = true,
    showCandidatesCount = 3,
  })

  local dictdir = vim.fs.joinpath(vim.fs.dirname(p.dir), "dict")
  vim.fn["skkeleton#config"]({
    globalDictionaries = {
      vim.fs.joinpath(dictdir, "SKK-JISYO.L"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.assoc"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.emoji"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.edict"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.edict2"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.fullname"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.geo"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.hukugougo"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.mazegaki"),
      vim.fs.joinpath(dictdir, "SKK-JISYO.propernoun"),
      -- vim.fs.joinpath(dictdir, "SKK-JISYO.station"),
    },
  })
end

-- @type LazySpec
local spec = {
  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim", "skk-dev/dict" },
    config = config,
  },
}
return spec
