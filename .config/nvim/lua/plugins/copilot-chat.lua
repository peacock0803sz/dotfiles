local function config()
  require("CopilotChat").setup({
    chat_autocomplete = true,
    mappings = {
      complete = {
        insert = "",
      },
    },
    prompts = {
      Refactor = {
        "/COPILOT_REVIEW Please Refactor the selected code.",
      },
    },
  })
end

---@type LazySpec
local spec = {
  "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "https://github.com/zbirenbaum/copilot.lua" },
    { "https://github.com/nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  config = config,
}
return spec
