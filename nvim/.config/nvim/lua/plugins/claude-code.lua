-- Claude Code IDE Integration (WebSocket MCP protocol, same as VS Code extension)
return {
  {
    "coder/claudecode.nvim",
    dependencies = {},
    opts = {
      terminal = {
        provider = "snacks",
        show_native_terminal_exit_tip = false,
      },
      diff_opts = {
        auto_close_on_accept = true,
        show_diff_stats = true,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>ca", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to Claude context" },
    },
  },
}
