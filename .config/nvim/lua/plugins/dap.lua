local function config()
  local dapui = require("dapui")
  local dap = require("dap")

  dap.set_log_level("DEBUG")

  dapui.setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    element_mappings = {},
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = "scopes", size = 0.25 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40, -- 40 columns
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
    controls = {
      -- Requires Neovim nightly (or 0.8 when released)
      enabled = true,
      -- Display controls in this element
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "",
        terminate = "",
      },
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = "single", -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil, -- Can be integer or nil.
      max_value_lines = 100, -- Can be integer or nil.
    },
  })

  -- Go
  require("dap-go").setup({
    dap_configurations = {
      {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
        remotePath = "/app",
      },
    },
    delve = {
      port = 2346,
    },
  })
  -- dap.adapters.delve = {
  --   type = "server",
  --   host = "127.0.0.1",
  --   port = 2346,
  --   executable = {
  --     command = vim.fn.exepath("dlv"),
  --     args = { "dap", "-l", "127.0.0.1:2346" },
  --   },
  -- }
  -- dap.configurations.go = {
  --   {
  --     type = "delve",
  --     name = "Debug",
  --     mode = "remote",
  --     request = "attach",
  --     showLog = true,
  --     dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
  --   },
  -- }

  require("dap.ext.vscode").load_launchjs()

  local opts = require("keymaps").opts

  vim.keymap.set("n", "<Space>du", dapui.toggle, opts)
  -- vim.keymap.set("n", "<Space>dc", "<Cmd>lua require('dap').continue()<CR>", opts)
  vim.keymap.set("n", "<Space>dc", dap.continue, opts)
  -- vim.keymap.set("n", "<Space>dl", "<Cmd>lua require('dap').launch()<CR>", opts)
  vim.keymap.set("n", "<Space>db", dap.toggle_breakpoint, opts)
  vim.keymap.set("n", "<Space>dd", dap.clear_breakpoints, opts)
end

local spec = {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "leoluz/nvim-dap-go" },
    config = config,
  },
}
return spec
