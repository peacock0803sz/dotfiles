local function config()
  -- Setup treesitter
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "org" },
    },
    ensure_installed = { "org" },
  })

  -- Setup orgmode
  require("orgmode").setup({
    org_agenda_files = "~/Documents/Notiz/**/*",
    org_default_notes_file = "~/Documents/Notiz/refile.org",
  })
end

---@type LazySpec
local spec = {
  "https://github.com/nvim-orgmode/orgmode",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = config,
}

return spec
