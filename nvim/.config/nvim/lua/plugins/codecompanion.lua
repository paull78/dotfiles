-- CodeCompanion: direct API chat with Claude (optional, needs ANTHROPIC_API_KEY)
-- Delete this file if you only want Claude Code CLI integration
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat toggle<cr>", desc = "AI Chat toggle", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions", mode = { "n", "v" } },
      { "<leader>aq", "<cmd>CodeCompanion<cr>", desc = "AI Quick prompt", mode = { "n", "v" } },
    },
    opts = {
      strategies = {
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = { default = "claude-sonnet-4-20250514" },
            },
          })
        end,
      },
      display = {
        chat = { window = { width = 0.4 } },
      },
    },
  },
}
