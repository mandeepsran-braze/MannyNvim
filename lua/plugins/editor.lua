return {
  -- Enhanced textobjects: vaf (function), vac (class), vaa (argument), etc.
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },

  -- Surround: sa (add), sd (delete), sr (replace)
  -- Example: saiw" wraps word in quotes, sd" removes quotes
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add            = "sa",
        delete         = "sd",
        find           = "sf",
        find_prev      = "sF",
        highlight      = "sh",
        replace        = "sr",
        update_n_lines = "sn",
      },
    },
  },

  -- Auto-close brackets and quotes
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Syntax highlighting and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "luadoc",
        "ruby", "eruby",
        "typescript", "tsx", "javascript",
        "html", "css", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "bash", "regex", "vim", "vimdoc",
        "sql",
      },
      auto_install = true,
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },

  -- Sticky function/class context header
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines       = 5,
      min_window_height = 20,
      mode            = "cursor",
      throttle        = true,
      patterns = {
        default    = { "class", "function", "method" },
        ruby       = { "class", "module", "method", "do_block" },
        typescript = { "class", "function", "arrow_function", "method_definition" },
      },
    },
  },
}
