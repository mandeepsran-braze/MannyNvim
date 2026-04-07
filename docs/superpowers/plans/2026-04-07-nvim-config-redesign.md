# Neovim Config Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a clean, modern Neovim config from scratch optimized for Ruby on Rails + TypeScript development with Claude Code AI integration.

**Architecture:** Domain-grouped plugin files under `lua/plugins/`, each a self-contained lazy.nvim spec table. Core editor config lives in `lua/config/`. Snacks.nvim handles the UI layer (dashboard, explorer, picker, notifications, terminal, indent). Mini.nvim handles editing primitives (textobjects, surround, pairs). Blink.cmp replaces nvim-cmp for completion. CodeCompanion provides Claude AI integration with a built-in Claude Code CLI tool.

**Tech Stack:** Neovim 0.11+, lazy.nvim, snacks.nvim, blink.cmp, supermaven-nvim, codecompanion.nvim (Anthropic/Claude), typescript-tools.nvim, ruby-lsp, mason.nvim, gruvbox.nvim, lualine.nvim, bufferline.nvim, gitsigns.nvim, lazygit.nvim, diffview.nvim, mini.ai/surround/pairs, nvim-treesitter, vim-rails.

---

## File Map

### Created
- `init.lua` — leader key, lazy bootstrap, loads `config/*` and `plugins/*`
- `lua/config/options.lua` — vim.opt settings
- `lua/config/keymaps.lua` — non-plugin keymaps (window nav, line move, quickfix, diagnostics)
- `lua/config/autocmds.lua` — highlight on yank, trim whitespace, resize splits, restore cursor
- `lua/plugins/ui.lua` — snacks, gruvbox, transparent, lualine, bufferline, which-key, todo-comments, rainbow-delimiters
- `lua/plugins/lsp.lua` — mason, mason-lspconfig, mason-tool-installer, lspconfig, typescript-tools, lazydev, blink.cmp, conform
- `lua/plugins/ai.lua` — codecompanion (Anthropic/Claude), supermaven
- `lua/plugins/git.lua` — gitsigns, lazygit, diffview
- `lua/plugins/editor.lua` — mini.ai, mini.surround, mini.pairs, nvim-treesitter, treesitter-context
- `lua/plugins/rails.lua` — vim-rails

### Backed up
- `~/.config/nvim.bak/` — full copy of current config before any changes

---

## Task 1: Backup and scaffold

**Files:**
- Create: `~/.config/nvim.bak/`
- Create: `lua/config/` and `lua/plugins/` directories

- [ ] **Step 1: Back up the current config**

```bash
cp -r ~/.config/nvim ~/.config/nvim.bak
ls ~/.config/nvim.bak
```

Expected: all current config files visible in `nvim.bak/`

- [ ] **Step 2: Remove existing config files (preserve .git and docs)**

```bash
cd ~/.config/nvim
find . -not -path './.git/*' -not -name '.git' \
       -not -path './docs/*' \
       -mindepth 1 -maxdepth 1 -exec rm -rf {} +
ls -la
```

Expected: only `.git/` and `docs/` remain

- [ ] **Step 3: Create directory structure**

```bash
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins
ls -R ~/.config/nvim/lua
```

Expected: `lua/config/` and `lua/plugins/` exist

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add -A
git commit -m "chore: backup and scaffold new config structure"
```

---

## Task 2: init.lua

**Files:**
- Create: `init.lua`

- [ ] **Step 1: Create init.lua**

```lua
-- Leader keys must be set before lazy loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config before plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "gruvbox", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
```

- [ ] **Step 2: Create placeholder config files so init.lua can require them**

```bash
touch ~/.config/nvim/lua/config/options.lua
touch ~/.config/nvim/lua/config/keymaps.lua
touch ~/.config/nvim/lua/config/autocmds.lua
```

- [ ] **Step 3: Verify lazy bootstraps without errors**

```bash
nvim --headless +qa 2>&1
```

Expected: no output or errors (lazy will clone itself on first run — that output is fine)

- [ ] **Step 4: Commit**

```bash
git add init.lua lua/config/
git commit -m "feat: add init.lua with lazy bootstrap"
```

---

## Task 3: config/options.lua

**Files:**
- Modify: `lua/config/options.lua`

- [ ] **Step 1: Write options.lua**

```lua
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.breakindent = true
opt.smartindent = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.fileencoding = "utf-8"
opt.hidden = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 1
opt.pumheight = 10
opt.conceallevel = 0

-- Whitespace visualization
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Performance
opt.timeoutlen = 300
opt.updatetime = 250

-- Completion
opt.completeopt = { "menuone", "noselect" }

-- Clipboard
opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"

-- Folding
opt.foldmethod = "manual"
opt.foldenable = false
```

- [ ] **Step 2: Verify option loads**

```bash
nvim --headless -c "lua print(vim.opt.tabstop:get())" -c qa 2>&1
```

Expected: `2`

- [ ] **Step 3: Commit**

```bash
git add lua/config/options.lua
git commit -m "feat: add editor options"
```

---

## Task 4: config/keymaps.lua and config/autocmds.lua

**Files:**
- Modify: `lua/config/keymaps.lua`
- Modify: `lua/config/autocmds.lua`

- [ ] **Step 1: Write keymaps.lua**

```lua
local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits
map("n", "<C-Up>",    ":resize -2<CR>",          { silent = true, desc = "Shrink window height" })
map("n", "<C-Down>",  ":resize +2<CR>",          { silent = true, desc = "Grow window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { silent = true, desc = "Shrink window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Grow window width" })

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==",        { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==",        { silent = true, desc = "Move line up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv",   { silent = true, desc = "Move block down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv",   { silent = true, desc = "Move block up" })

-- Stay in visual mode after indent
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Quickfix
map("n", "]q", ":cnext<CR>", { silent = true, desc = "Next quickfix item" })
map("n", "[q", ":cprev<CR>", { silent = true, desc = "Prev quickfix item" })

-- Diagnostics
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { silent = true })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { silent = true })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { silent = true })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { silent = true })

-- Command mode tab completion
map("c", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, noremap = true })
map("c", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, noremap = true })
```

- [ ] **Step 2: Write autocmds.lua**

```lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
  desc = "Highlight text on yank",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Equalize splits on window resize
autocmd("VimResized", {
  desc = "Equalize splits on resize",
  group = augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Trim trailing whitespace on save
autocmd("BufWritePre", {
  desc = "Trim trailing whitespace",
  group = augroup("trim-whitespace", { clear = true }),
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Restore cursor to last known position
autocmd("BufReadPost", {
  desc = "Restore cursor position",
  group = augroup("restore-cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
```

- [ ] **Step 3: Verify config layer loads cleanly**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 4: Commit**

```bash
git add lua/config/keymaps.lua lua/config/autocmds.lua
git commit -m "feat: add keymaps and autocmds"
```

---

## Task 5: plugins/ui.lua

**Files:**
- Create: `lua/plugins/ui.lua`

- [ ] **Step 1: Create plugins/ui.lua**

```lua
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
      { "<leader>pS", "<cmd>Lazy clear<cr>",    desc = "Status" },
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
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors (plugins install on first real launch)

- [ ] **Step 3: Launch nvim and verify dashboard**

```
nvim
```

Expected: gruvbox dashboard appears with header and recent files section

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/ui.lua
git commit -m "feat: add UI plugins (snacks, gruvbox, lualine, bufferline, which-key)"
```

---

## Task 6: plugins/lsp.lua

**Files:**
- Create: `lua/plugins/lsp.lua`

- [ ] **Step 1: Create plugins/lsp.lua**

```lua
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
          source = "always",
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
          map("gt", function() Snacks.picker.lsp_type_definitions() end, "Go to Type Definition")

          -- LSP leader group
          require("which-key").add({
            { "<leader>la", vim.lsp.buf.code_action,                                                                  desc = "Code Action",          buffer = event.buf },
            { "<leader>ld", function() Snacks.picker.diagnostics({ buf_only = true }) end,                           desc = "Buffer Diagnostics",   buffer = event.buf },
            { "<leader>lw", function() Snacks.picker.diagnostics() end,                                               desc = "Workspace Diagnostics", buffer = event.buf },
            { "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end,          desc = "Format",               buffer = event.buf },
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
    event = "InsertEnter",
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
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 3: Open a Ruby file and verify LSP attaches**

```
nvim test.rb
:LspInfo
```

Expected: `ruby_lsp` listed as attached (Mason installs it on first run — run `:MasonInstall ruby-lsp` if needed)

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "feat: add LSP, blink.cmp, and conform"
```

---

## Task 7: plugins/ai.lua

**Files:**
- Create: `lua/plugins/ai.lua`

> Requires `ANTHROPIC_API_KEY` set in your shell environment. Add `export ANTHROPIC_API_KEY="sk-ant-..."` to `~/.zshrc` or `~/.zprofile` if not already present.

- [ ] **Step 1: Create plugins/ai.lua**

```lua
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
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 3: Verify CodeCompanion opens**

```
nvim
<Space>ac
```

Expected: chat panel opens on the right

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/ai.lua
git commit -m "feat: add CodeCompanion (Claude) and Supermaven"
```

---

## Task 8: plugins/git.lua

**Files:**
- Create: `lua/plugins/git.lua`

- [ ] **Step 1: Create plugins/git.lua**

```lua
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
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 3: Open a tracked file and verify gitsigns**

```
nvim lua/config/options.lua
```

Expected: git change signs visible in the gutter

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/git.lua
git commit -m "feat: add git plugins (gitsigns, lazygit, diffview)"
```

---

## Task 9: plugins/editor.lua

**Files:**
- Create: `lua/plugins/editor.lua`

- [ ] **Step 1: Create plugins/editor.lua**

```lua
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
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 3: Verify treesitter highlighting**

```
nvim lua/config/options.lua
:TSBufInfo
```

Expected: lua parser listed as active

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/editor.lua
git commit -m "feat: add editor plugins (mini.nvim, treesitter)"
```

---

## Task 10: plugins/rails.lua

**Files:**
- Create: `lua/plugins/rails.lua`

- [ ] **Step 1: Create plugins/rails.lua**

```lua
return {
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby", "haml", "slim" },
    config = function()
      require("which-key").add({
        { "<leader>r",  group = "Rails" },
        { "<leader>ra", "<cmd>A<cr>",           desc = "Alternate file (test<->impl)" },
        { "<leader>rr", "<cmd>R<cr>",           desc = "Related file" },
        { "<leader>rm", "<cmd>Emodel<cr>",      desc = "Go to model" },
        { "<leader>rc", "<cmd>Econtroller<cr>", desc = "Go to controller" },
        { "<leader>rv", "<cmd>Eview<cr>",       desc = "Go to view" },
        { "<leader>rs", "<cmd>Espec<cr>",       desc = "Go to spec" },
        { "<leader>ri", "<cmd>Emigration<cr>",  desc = "Go to migration" },
        { "<leader>rf", "<cmd>Efixtures<cr>",   desc = "Go to fixture" },
        { "<leader>rl", "<cmd>Elocale<cr>",     desc = "Go to locale" },
        { "<leader>rj", "<cmd>Ejavascript<cr>", desc = "Go to javascript" },
      })
    end,
  },
}
```

- [ ] **Step 2: Verify load**

```bash
nvim --headless +qa 2>&1
```

Expected: no errors

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/rails.lua
git commit -m "feat: add vim-rails"
```

---

## Task 11: Final verification

- [ ] **Step 1: Run health check**

```
nvim
:checkhealth
```

Review output. LSP, treesitter, and mason should be green. Note any warnings.

- [ ] **Step 2: Verify which-key groups**

```
nvim
<Space>
```

Expected: groups visible — Buffers, Git, LSP, Rails, Search, Plugins, AI, UI/Utils

- [ ] **Step 3: Verify blink.cmp + supermaven coexistence**

Open a Ruby or TypeScript file and enter insert mode.
- Typing should show blink.cmp menu with LSP completions
- After a brief pause, supermaven ghost text appears in italics
- `<Tab>` when the blink menu is open: confirms top completion
- `<Tab>` when only supermaven ghost text is visible: accepts the ghost text
- `<C-]>`: clears supermaven ghost text

- [ ] **Step 4: Verify Claude CodeCompanion**

```
nvim
<Space>ac
```

Expected: chat panel opens on the right. Send a message — Claude should respond if `ANTHROPIC_API_KEY` is set.
To use Claude Code CLI as an agent inside the chat, type `/claude-code` in the chat buffer.

- [ ] **Step 5: Final commit**

```bash
cd ~/.config/nvim
git add -A
git commit -m "feat: complete neovim config redesign"
```
