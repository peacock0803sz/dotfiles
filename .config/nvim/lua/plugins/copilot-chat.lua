local function config()
  require("CopilotChat.integrations.cmp").setup()
  require("CopilotChat").setup({
    mappings = {
      complete = {
        insert = "",
      },
    },
    prompts = {
      Refactor = {
        "/COPILOT_REVIEW Please Refactor the selected code."
      }
    },
  })
end

---@type LazySpec
local spec = {
  "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "https://github.com/zbirenbaum/copilot.lua" },
    { "https://github.com/nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  config = config,
}
return spec
