return {
  -- Ghost text inline completions (Tab to accept, C-] to clear, C-l to accept word)
  -- Use Claude Code CLI via the snacks terminal: <C-\>
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion  = "<C-]>",
        accept_word       = "<C-l>",
      },
      ignore_filetypes = {},
      log_level = "off",
    },
  },
}
