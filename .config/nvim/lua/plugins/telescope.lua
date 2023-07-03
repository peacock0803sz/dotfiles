local function config()
  local join_table = require("utils").join_table

  local utils = require("telescope.utils")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
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

  local function change_dir(bufnr)
    local selection = action_state.get_selected_entry()
    vim.cmd("silent lcd " .. vim.fn.fnamemodify(selection.path, ":p:h"))
    actions.close(bufnr)
    vim.print("Changed dir to " .. vim.fn.getcwd())
  end

  require("telescope").setup({
    defaults = {
      vimgrep_arguments = grep_args,
      wrap_results = true,
      preview = {
        treesitter = true,
      },
      layout_config = {
        vertical = {
          width = 0.95,
        },
        horizontal = {
          width = 0.95,
          preview_width = 0.45,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = find_command,
        mappings = {
          ["n"] = {
            ["cd"] = change_dir,
          },
        },
      },
      live_grep = {
        vimgrep_arguments = grep_args,
      },
      recent_used_files = {
        picker_config_key = recent_used_files,
      },
      recent_written_files = {
        picker_config_key = recent_written_files,
      },
      git_status = {
        mappings = {
          ["n"] = {
            ["cd"] = change_dir,
          },
        },
      },
      git_stash = {
        mappings = {
          ["n"] = {},
        },
      },
    },
    extensions = {
      file_browser = {
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          ["i"] = {
            ["<C-R>"] = actions.select_drop,
            ["<C-d>"] = actions.git_switch_branch,
          },
          ["n"] = {
            ["cd"] = change_dir,
          },
        },
      },
    },
  })

  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "<space>ff", builtin.find_files, { silent = true })
  vim.keymap.set("n", "<space>fg", builtin.live_grep, { silent = true })
  vim.keymap.set("n", "<space>fb", builtin.buffers, { silent = true })
  vim.keymap.set("n", "<space>fh", builtin.help_tags, { silent = true })
  vim.keymap.set("n", "<space>fc", builtin.commands, { silent = true })
  vim.keymap.set("n", "<space>fr", recent_used_files, { silent = true })
  vim.keymap.set("n", "<space>fw", recent_written_files, { silent = true })

  vim.keymap.set("n", "<space>gc", builtin.git_commits, { silent = true })
  vim.keymap.set("n", "<space>gC", builtin.git_bcommits, { silent = true })
  vim.keymap.set("n", "<space>gb", builtin.git_branches, { silent = true })
  vim.keymap.set("n", "<space>gs", builtin.git_status, { silent = true })
  vim.keymap.set("n", "<space>gS", builtin.git_stash, { silent = true })

  vim.keymap.set("n", "<space>lr", builtin.lsp_references, { silent = true })
  vim.keymap.set("n", "<space>ls", builtin.lsp_workspace_symbols, { silent = true })
  vim.keymap.set("n", "<space>ld", builtin.lsp_definitions, { silent = true })
  vim.keymap.set("n", "<space>lt", builtin.lsp_type_definitions, { silent = true })
  vim.keymap.set("n", "<space>li", builtin.lsp_implementations, { silent = true })
  vim.keymap.set("n", "<space>le", builtin.diagnostics, { silent = true })

  -- extensions
  require("telescope").load_extension("file_browser")
  vim.keymap.set("n", "<space>F", "<Cmd>Telescope file_browser<CR>", { silent = true })
end

local spec = {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "lambdalisue/mr.vim" },
    config = config,
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
}
return spec
