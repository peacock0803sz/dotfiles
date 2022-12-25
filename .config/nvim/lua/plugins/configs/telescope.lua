local join_table = require("utils").join_table

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local recent_written_files = function(opts)
  local safe_opts = opts or {}
  local list = vim.fn["mr#mrw#list"]()
  pickers
    .new(safe_opts, {
      prompt_title = "Recent written files",
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = conf.file_sorter(safe_opts),
    })
    :find()
end

local recent_used_files = function(opts)
  local safe_opts = opts or {}
  local list = vim.fn["mr#mru#list"]()
  pickers
    .new(safe_opts, {
      prompt_title = "Recent used files",
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = conf.file_sorter(safe_opts),
    })
    :find()
end

local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments
local include_dotfiles = { "--hidden", "--glob", "!.git/*" }

local grep_args = join_table(vimgrep_arguments, include_dotfiles)
local find_command = join_table({ "rg", "--files" }, include_dotfiles)

require("telescope").setup({
  defaults = {
    vimgrep_arguments = grep_args,
  },
  pickers = {
    find_files = {
      find_command = find_command,
    },
    recent_used_files = {
      picker_config_key = recent_used_files,
    },
    recent_written_files = {
      picker_config_key = recent_written_files,
    },
  },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<space>ff", builtin.find_files, { silent = true })
vim.keymap.set("n", "<space>fg", builtin.live_grep, { silent = true })
vim.keymap.set("n", "<space>fb", builtin.buffers, { silent = true })
vim.keymap.set("n", "<space>fh", builtin.help_tags, { silent = true })
vim.keymap.set("n", "<space>fr", recent_used_files, { silent = true })
vim.keymap.set("n", "<space>fw", recent_written_files, { silent = true })

vim.keymap.set("n", "<space>gc", builtin.git_commits, { silent = true })
vim.keymap.set("n", "<space>gC", builtin.git_bcommits, { silent = true })
vim.keymap.set("n", "<space>gb", builtin.git_branches, { silent = true })
vim.keymap.set("n", "<space>ga", builtin.git_status, { silent = true })
vim.keymap.set("n", "<space>gs", builtin.git_stash, { silent = true })
