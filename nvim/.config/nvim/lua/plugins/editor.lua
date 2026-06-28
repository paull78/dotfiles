-- Editor enhancements (neo-tree, telescope, git tweaks)
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      picker = { sources = { explorer = { auto_close = true } } },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local function open_with_diff(state)
        local node = state.tree:get_node()
        if not node or node.type ~= "file" then return end

        local target
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft ~= "neo-tree" and ft ~= "neo-tree-popup" then
            target = win
            break
          end
        end

        if target then
          vim.api.nvim_set_current_win(target)
        else
          vim.cmd("wincmd l")
        end

        vim.cmd("edit " .. vim.fn.fnameescape(node.path))
        vim.schedule(function()
          local ok, gs = pcall(require, "gitsigns")
          if ok then gs.diffthis() else vim.cmd("Gdiffsplit") end
        end)
      end

      return vim.tbl_deep_extend("force", opts or {}, {
        sources = { "filesystem", "git_status", "buffers" },
        source_selector = {
          winbar = true,
          sources = {
            { source = "filesystem", display_name = "  Files" },
            { source = "git_status", display_name = "  Git" },
            { source = "buffers", display_name = "  Buffers" },
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { "node_modules", ".git", ".DS_Store" },
          },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        git_status = {
          window = {
            mappings = {
              ["<cr>"] = open_with_diff,
              ["o"] = open_with_diff,
              ["O"] = "open",
            },
          },
        },
        window = {
          width = 35,
          mappings = { ["<space>"] = "none" },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = { default_mappings = true, disable_diagnostics = true },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },
}
