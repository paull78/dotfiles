-- Colorscheme & UI
return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- Rich git status in bottom; filename in winbar at top
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_b = {
        "branch",
        {
          "diff",
          source = function()
            local gs = vim.b.gitsigns_status_dict
            if gs then
              return { added = gs.added, modified = gs.changed, removed = gs.removed }
            end
          end,
        },
      }
      opts.sections.lualine_c = {}

      opts.winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename", path = 1, symbols = { modified = "  ", readonly = "  " } },
        },
        lualine_x = { "diagnostics" },
        lualine_y = {},
        lualine_z = {},
      }
      opts.inactive_winbar = {
        lualine_c = {
          { "filename", path = 1, color = { fg = "#6c7086" } },
        },
      }
    end,
  },
}
