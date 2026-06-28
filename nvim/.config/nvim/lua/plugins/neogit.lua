-- VSCode "Source Control" style left panel
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit kind=vsplit<cr>", desc = "Source Control (Neogit)" },
      { "<leader>gN", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Source Control (file dir)" },
      { "<leader>gC", "<cmd>Neogit commit<cr>", desc = "Commit" },
    },
    opts = {
      kind = "vsplit",
      graph_style = "unicode",
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      sections = {
        untracked = { folded = false, hidden = false },
        unstaged = { folded = false, hidden = false },
        staged = { folded = false, hidden = false },
        recent = { folded = true, hidden = false },
        unmerged = { folded = false, hidden = false },
      },
    },
  },
}
