-- Claude Code IDE Integration (WebSocket MCP protocol, same as VS Code extension)
return {
  {
    "coder/claudecode.nvim",
    dependencies = {},
    lazy = false,
    opts = {
      terminal = {
        provider = "snacks",
        show_native_term_exit_tip = false,
      },
      diff_opts = {
        auto_close_on_accept = true,
        show_diff_stats = true,
      },
    },
    keys = {
      { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>af", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to Claude context" },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      local function open()
        vim.schedule(function()
          vim.cmd("ClaudeCode")
        end)
      end
      if vim.v.vim_did_enter == 1 then
        open()
      else
        vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = open })
      end
    end,
  },
}
