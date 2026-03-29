-- JS/TS Development
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript-language-server",
        "json-lsp",
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettierd",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "relative",
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                functionLikeReturnTypes = { enabled = true },
              },
            },
          },
        },
      },
    },
  },
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = "json",
    opts = { hide_up_to_date = true, package_manager = "npm" },
    keys = {
      { "<leader>cp", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle package versions" },
      { "<leader>cu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package" },
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript", "tsx", "javascript", "jsdoc",
        "json", "json5", "jsonc",
        "html", "css", "markdown", "markdown_inline",
        "lua", "bash", "yaml", "toml",
        "diff", "gitcommit", "gitignore",
      })
    end,
  },
}
