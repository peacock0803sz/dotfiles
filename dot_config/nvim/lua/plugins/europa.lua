local function config()
  vim.g.europa_image_backend = "sixel" -- 'auto', 'sixel', 'kitty', 'iterm2_osc1337'
  vim.g.europa_mime_priority = { "image/png", "image/jpeg", "text/html", "text/plain" }
  vim.g.europa_max_output_lines = 100
  vim.g.europa_cell_border_chars = { "╭", "─", "╮", "╰", "╯" }
  vim.g.europa_cell_border_padding = 88
  vim.g.europa_lazy_padding = 10

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "europa" },
    group = vim.api.nvim_create_augroup("EuropaConfig", { clear = true }),
    callback = function(args)
      ---@type vim.api.keyset.keymap
      local opts = { silent = true }

      -- Execution (JupyterLab Shift-Enter / Ctrl-Enter / Alt-Enter).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<Space>", "<localleader>", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<S-CR>", "<Plug>(europa-run-cell)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<C-CR>", "<Plug>(europa-run-cell)", opts)
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<M-CR>",
        "<Plug>(europa-run-cell)<Plug>(europa-insert-code)",
        opts
      )

      -- Cell insertion (JupyterLab A above / B below).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "a", "<Plug>(europa-insert-code-above)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "b", "<Plug>(europa-insert-code)", opts)

      -- Cell deletion / merge / split (JupyterLab D D / Shift-M / Ctrl-Shift--).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "dd", "<Plug>(europa-delete-cell)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "M", "<Plug>(europa-join-cell)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "-", "<Plug>(europa-split-cell)", opts)

      -- Edit cell body in scratch (JupyterLab Enter to enter edit mode).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<CR>", "<Plug>(europa-edit-cell)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "i", "<Plug>(europa-edit-cell)", opts)

      -- Kernel control (JupyterLab I I interrupt / 0 0 restart).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "ii", "<Plug>(europa-interrupt)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "00", "<Plug>(europa-restart-kernel)", opts)

      -- Cell type lives under <localleader> so Vim's m / y / r single-key
      -- primitives (mark, yank operator, replace-char) stay usable.
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>m",
        "<Plug>(europa-celltype-markdown)",
        opts
      )
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>y",
        "<Plug>(europa-celltype-code)",
        opts
      )
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>r",
        "<Plug>(europa-cell-type-raw)",
        opts
      )
      -- Auxiliary (no JupyterLab single-key equivalent).
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<localleader>R", "<Plug>(europa-run-all)", opts)
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>c",
        "<Plug>(europa-cancel-cell)",
        opts
      )
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<localleader>k", "<Plug>(europa-cell-up)", opts)
      vim.api.nvim_buf_set_keymap(args.buf, "n", "<localleader>j", "<Plug>(europa-cell-down)", opts)

      -- Kernel lifecycle (no JupyterLab single-key equivalent).
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>s",
        "<Plug>(europa-start-kernel)",
        opts
      )
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>q",
        "<Plug>(europa-shutdown-kernel)",
        opts
      )
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<localleader>K",
        "<Plug>(europa-kernel-status)",
        opts
      )
    end,
  })
end

---@type LazySpec
local spec = { "https://github.com/peacock0803sz/Europa.vim", config = config, dev = true }
return spec
