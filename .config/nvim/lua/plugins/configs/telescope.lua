local join_table = require("utils").join_table

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
  },
})

vim.keymap.set("n", "<space>ff", "<Cmd>Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<space>fg", "<Cmd>Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<space>fb", "<Cmd>Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<space>fh", "<Cmd>Telescope help_tags<CR>", { silent = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>gc", builtin.git_commits, { silent = true })
vim.keymap.set("n", "<space>gC", builtin.git_bcommits, { silent = true })
vim.keymap.set("n", "<space>gb", builtin.git_branches, { silent = true })
vim.keymap.set("n", "<space>ga", builtin.git_status, { silent = true })
vim.keymap.set("n", "<space>gs", builtin.git_stash, { silent = true })
