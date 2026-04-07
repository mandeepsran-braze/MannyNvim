return {
  -- Lua LSP completions for Neovim config files
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  -- LSP server installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason + lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "ruby_lsp", "lua_ls" },
      automatic_installation = true,
    },
  },

  -- Auto-install formatters and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "stylua", "rubocop", "erb-lint" },
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Diagnostic display config
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Go-to keymaps
          map("gd", function() Snacks.picker.lsp_definitions() end,      "Go to Definition")
          map("gD", vim.lsp.buf.declaration,                              "Go to Declaration")
          map("gh", vim.lsp.buf.hover,                                    "Hover")
          map("gI", function() Snacks.picker.lsp_implementations() end,  "Go to Implementation")
          map("gr", function() Snacks.picker.lsp_references() end,       "Go to References")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Go to Type Definition")

          -- LSP leader group
          require("which-key").add({
            { "<leader>la", vim.lsp.buf.code_action,                                                                  desc = "Code Action",          buffer = event.buf },
            { "<leader>ld", function() Snacks.picker.diagnostics({ buf_only = true }) end,                           desc = "Buffer Diagnostics",   buffer = event.buf },
            { "<leader>lw", function() Snacks.picker.diagnostics() end,                                               desc = "Workspace Diagnostics", buffer = event.buf },
            { "<leader>lf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end,      desc = "Format",               buffer = event.buf },
            { "<leader>li", "<cmd>LspInfo<cr>",                                                                        desc = "Info",                 buffer = event.buf },
            { "<leader>lI", "<cmd>Mason<cr>",                                                                          desc = "Mason Info",           buffer = event.buf },
            { "<leader>lr", vim.lsp.buf.rename,                                                                        desc = "Rename",               buffer = event.buf },
            { "<leader>ls", function() Snacks.picker.lsp_symbols() end,                                               desc = "Document Symbols",     buffer = event.buf },
            { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end,                                     desc = "Workspace Symbols",    buffer = event.buf },
            { "<leader>ll", vim.lsp.codelens.run,                                                                      desc = "CodeLens Action",      buffer = event.buf },
          })
        end,
      })

      -- Ruby LSP
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        init_options = {
          formatter = "rubocop",
          linters = { "rubocop" },
        },
      })

      -- Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },

  -- TypeScript: direct tsserver communication (faster than ts_ls)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    },
  },

  -- Completion engine (replaces nvim-cmp)
  {
    "saghen/blink.cmp",
    version = "*",
    lazy = true,
    opts = {
      keymap = {
        preset = "default",
        -- Tab: accept top item if menu open, otherwise falls through to supermaven
        ["<Tab>"]   = { "select_and_accept", "fallback" },
        ["<C-j>"]   = { "select_next", "fallback" },
        ["<C-k>"]   = { "select_prev", "fallback" },
        ["<C-d>"]   = { "scroll_documentation_down", "fallback" },
        ["<C-u>"]   = { "scroll_documentation_up", "fallback" },
        ["<C-e>"]   = { "cancel", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
          },
        },
        -- Disable blink ghost text: supermaven handles this
        ghost_text = { enabled = false },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua    = { "stylua" },
        ruby   = { "rubocop" },
        eruby  = { "erb_lint" },
      },
      format_on_save = false,
      notify_on_error = true,
    },
  },
}
