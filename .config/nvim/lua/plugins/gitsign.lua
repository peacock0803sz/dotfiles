local function config()
  local gitsigns = package.loaded.gitsigns

  require("gitsigns").setup({
    on_attach = function(_)
      -- next hunk
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          do
            return "]c"
          end
          vim.schedule(function()
            gitsigns.next_hunk()
          end)
        end
        return "<Ignore>"
      end)
      -- previous hunk
      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          do
            return "[c"
          end
          vim.schedule(function()
            gitsigns.prev_hunk()
          end)
        end
      end)
    end,
  })
end

local spec = { "lewis6991/gitsigns.nvim", config = config, event = "BufEnter" }
return spec
