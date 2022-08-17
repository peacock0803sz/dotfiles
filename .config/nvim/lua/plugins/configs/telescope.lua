local join_table = require("utils").join_table

local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments
local include_dotfiles = {"--hidden", "--glob", "!.git/*"}

local grep_args = join_table(vimgrep_arguments, include_dotfiles)
local find_command = join_table({"rg", "--files"}, include_dotfiles)

require("telescope").setup{
  defaults = {
    vimgrep_arguments = grep_args
  },
  pickers = {
    find_files = {
      find_command = find_command
    }
  }
}

vim.api.nvim_set_keymap("n", "<space>ff", ":<C-u>Telescope find_files<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<space>fg", ":<C-u>Telescope live_grep<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<space>fe", ":<C-u>Telescope buffers<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<space>fh", ":<C-u>Telescope help_tags<CR>", {silent = true})
