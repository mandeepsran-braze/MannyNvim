return {
  -- Claude AI coding assistant
  -- In chat: type /claude-code to invoke Claude Code CLI as an agent inside Neovim
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",  desc = "Chat Toggle", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<cr>",             desc = "Inline Assist", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",      desc = "Action Palette", mode = { "n", "v" } },
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-sonnet-4-6",
              },
            },
          })
        end,
      },
      strategies = {
        chat    = { adapter = "anthropic" },
        inline  = { adapter = "anthropic" },
        agent   = { adapter = "anthropic" },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
            border = "rounded",
          },
        },
      },
      opts = {
        log_level = "ERROR",
      },
    },
  },

  -- Ghost text inline completions (Tab to accept, C-] to clear)
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion  = "<C-]>",
        accept_word       = "<C-j>",
      },
      ignore_filetypes = {},
      log_level = "off",
    },
  },
}
