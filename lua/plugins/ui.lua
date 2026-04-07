return {
  -- Gruvbox colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = true,
  },

  -- Icons (used by bufferline, lualine, snacks)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Snacks: dashboard, explorer, picker, notifications, indent, terminal, scroll, statuscolumn
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", limit = 5, padding = 1 },
          { section = "startup" },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = {
        enabled = true,
        layout = { preset = "telescope" },
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      terminal = {
        enabled = true,
        win = {
          position = "float",
          border = "rounded",
          height = 0.8,
          width = 0.8,
        },
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    keys = {
      -- Top level
      { "<leader>w", "<cmd>w!<cr>",                                                    desc = "Save" },
      { "<leader>q", "<cmd>confirm q<cr>",                                             desc = "Quit" },
      { "<leader>c", function() Snacks.bufdelete() end,                                desc = "Close Buffer" },
      { "<leader>e", function() Snacks.explorer() end,                                 desc = "Explorer" },
      { "<leader>f", function() Snacks.picker.files() end,                             desc = "Find File" },
      { "<C-\\>",    function() Snacks.terminal() end,                                 desc = "Toggle Terminal", mode = { "n", "t" } },

      -- Buffers
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",                                  desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",                                  desc = "Next Buffer" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>",                                       desc = "Jump" },
      { "<leader>bf", function() Snacks.picker.buffers() end,                          desc = "Find" },
      { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>",                                  desc = "Previous" },
      { "<leader>bn", "<cmd>BufferLineCycleNext<cr>",                                  desc = "Next" },
      { "<leader>bW", "<cmd>noautocmd w<cr>",                                          desc = "Save without formatting" },
      { "<leader>be", "<cmd>BufferLinePickClose<cr>",                                  desc = "Pick which buffer to close" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>",                                  desc = "Close all to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>",                                 desc = "Close all to the right" },
      { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>",                            desc = "Sort by directory" },
      { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>",                            desc = "Sort by language" },

      -- Search
      { "<leader>s/", function() Snacks.picker.lines() end,                            desc = "Search in Buffer" },
      { "<leader>sf", function() Snacks.picker.files() end,                            desc = "Find File" },
      { "<leader>sr", function() Snacks.picker.recent() end,                           desc = "Open Recent File" },
      { "<leader>st", function() Snacks.picker.grep() end,                             desc = "Find Text" },
      { "<leader>sk", function() Snacks.picker.keymaps() end,                          desc = "Keymaps" },
      { "<leader>sC", function() Snacks.picker.commands() end,                         desc = "Commands" },
      { "<leader>sl", function() Snacks.picker.resume() end,                           desc = "Resume last search" },
      { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search Nvim Config" },
      { "<leader>sc", function() Snacks.picker.colorschemes() end,                     desc = "Colorscheme" },

      -- Plugins
      { "<leader>pi", "<cmd>Lazy install<cr>",  desc = "Install" },
      { "<leader>ps", "<cmd>Lazy sync<cr>",     desc = "Sync" },
      { "<leader>pS", "<cmd>Lazy<cr>",            desc = "Status" },
      { "<leader>pc", "<cmd>Lazy clean<cr>",    desc = "Clean" },
      { "<leader>pu", "<cmd>Lazy update<cr>",   desc = "Update" },
      { "<leader>pp", "<cmd>Lazy profile<cr>",  desc = "Profile" },
      { "<leader>pl", "<cmd>Lazy log<cr>",      desc = "Log" },
      { "<leader>pd", "<cmd>Lazy debug<cr>",    desc = "Debug" },

      -- Notifications
      { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>ux", function() Snacks.notifier.hide() end,         desc = "Dismiss Notifications" },
    },
    init = function()
      -- Register which-key groups once VeryLazy fires
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          require("which-key").add({
            { "<leader>b", group = "Buffers" },
            { "<leader>g", group = "Git" },
            { "<leader>l", group = "LSP" },
            { "<leader>r", group = "Rails" },
            { "<leader>s", group = "Search" },
            { "<leader>p", group = "Plugins" },
            { "<leader>a", group = "AI" },
            { "<leader>u", group = "UI/Utils" },
          })
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "gruvbox-material",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        hover = { enabled = true, delay = 200, reveal = { "close" } },
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "Explorer",
            highlight = "Directory",
          },
        },
      },
    },
  },

  -- Keymap discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = {
        border = "double",
        padding = { 1, 2 },
        title = true,
        title_pos = "center",
      },
      layout = {
        width = { min = 40 },
        spacing = 5,
      },
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,
      notify = false,
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        keys = {
          Up = " ", Down = " ", Left = " ", Right = " ",
          C = "󰘴 ", M = "󰘵 ", S = "󰘶 ",
          CR = "󰌑 ", Esc = "󱊷 ", Space = "󱁐 ", Tab = "󰌒 ",
        },
      },
    },
  },

  -- TODO/FIXME highlights
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Rainbow bracket matching
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = require("rainbow-delimiters").strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
      })
    end,
  },
}
