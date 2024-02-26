local function config()
  vim.fn["altercmd#define"]("GinDiff", [[GinDiff ++processor=delta\\ --color-only --staged]])
end

local function init()
  vim.api.nvim_create_autocmd("FileType", {
    desc = "High-level reproduction of highlights by delta via GinDiff",
    -- group = group,
    pattern = "gin-diff",
    callback = function(ctx)
      local nm = vim.api.nvim_buf_get_name(ctx.buf)
      if not nm:match("processor=delta") then
        return
      end
      -- vim.api.nvim_set_hl(0, "DeltaLineAdded", { bg = "#efffef" })
      -- vim.api.nvim_set_hl(0, "DeltaLineDeleted", { bg = "#ffefef"})
      vim.api.nvim_set_hl(0, "DeltaLineAdded", { bg = "#ddffdd" })
      vim.api.nvim_set_hl(0, "DeltaLineDeleted", { bg = "#ffdddd" })
      require("tsnode-marker").set_automark(ctx.buf, {
        target = { "line_deleted", "line_added" },
        hl_group = function(_, node)
          local t = node:type()
          return ({
            line_added = "DeltaLineAdded",
            line_deleted = "DeltaLineDeleted",
          })[t] or "None"
        end,
        priority = 101, -- to override treesitter highlighting
      })
    end,
  })
end

---@type LazySpec[]
local spec = {
  {
    "https://github.com/lambdalisue/gin.vim",
    dependencies = {
      "https://github.com/vim-denops/denops.vim",
      "https://github.com/kana/vim-altercmd",
    },
    config = config,
  },
  {
    "https://github.com/atusy/tsnode-marker.nvim",
    init = init,
  },
}
return spec
