return {
  -- Inline git signs, blame, hunk navigation
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Hunk navigation
        map("n", "]h", function() gs.next_hunk({ navigation_message = false }) end, "Next Hunk")
        map("n", "[h", function() gs.prev_hunk({ navigation_message = false }) end, "Prev Hunk")

        -- Git leader group
        require("which-key").add({
          { "<leader>gg", "<cmd>LazyGit<cr>",                                                     desc = "LazyGit",              buffer = buffer },
          { "<leader>gj", function() gs.next_hunk({ navigation_message = false }) end,            desc = "Next Hunk",            buffer = buffer },
          { "<leader>gk", function() gs.prev_hunk({ navigation_message = false }) end,            desc = "Prev Hunk",            buffer = buffer },
          { "<leader>gl", function() gs.blame_line() end,                                         desc = "Blame Line",           buffer = buffer },
          { "<leader>gp", function() gs.preview_hunk() end,                                       desc = "Preview Hunk",         buffer = buffer },
          { "<leader>gr", function() gs.reset_hunk() end,                                         desc = "Reset Hunk",           buffer = buffer },
          { "<leader>gR", function() gs.reset_buffer() end,                                       desc = "Reset Buffer",         buffer = buffer },
          { "<leader>gs", function() gs.stage_hunk() end,                                         desc = "Stage Hunk",           buffer = buffer },
          { "<leader>gu", function() gs.undo_stage_hunk() end,                                    desc = "Undo Stage Hunk",      buffer = buffer },
          { "<leader>gd", "<cmd>DiffviewOpen<cr>",                                                desc = "Diffview",             buffer = buffer },
          { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",                                       desc = "File History",         buffer = buffer },
          { "<leader>go", function() Snacks.picker.git_status() end,                              desc = "Open changed files",   buffer = buffer },
          { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Checkout branch",      buffer = buffer },
          { "<leader>gc", function() Snacks.picker.git_log() end,                                 desc = "Checkout commit",      buffer = buffer },
        })
      end,
    },
  },

  -- LazyGit TUI
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- Diff viewer and merge conflict resolution
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },
}
