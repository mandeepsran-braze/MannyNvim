# Neovim Config Redesign — Design Spec
**Date:** 2026-04-07  
**Status:** Approved

---

## Overview

Fresh neovim config built from scratch. Gruvbox stays. Domain-grouped plugin structure. Optimized for Ruby on Rails + TypeScript development with first-class Claude Code AI integration.

Current config backed up to `~/.config/nvim.bak/` before any changes.

---

## File Structure

```
~/.config/nvim/
├── init.lua                     # bootstraps lazy, loads config/*, loads plugins/*
└── lua/
    ├── config/
    │   ├── options.lua          # vim.opt settings
    │   ├── keymaps.lua          # non-plugin keymaps (window nav, line move, quickfix)
    │   └── autocmds.lua         # highlight on yank, etc.
    └── plugins/
        ├── ui.lua               # snacks, lualine, bufferline, gruvbox, which-key, todo-comments, rainbow-delimiters
        ├── lsp.lua              # mason, lspconfig, typescript-tools, blink.cmp, conform, lazydev
        ├── ai.lua               # codecompanion, supermaven
        ├── git.lua              # gitsigns, lazygit, diffview
        ├── editor.lua           # mini.ai, mini.surround, mini.pairs, treesitter, treesitter-context
        └── rails.lua            # vim-rails
```

Each plugin file is a self-contained lazy spec table — no `M.setup()` wrapper pattern.

---

## Plugin Stack

### UI (`plugins/ui.lua`)
| Plugin | Purpose |
|--------|---------|
| `ellisonleao/gruvbox.nvim` | Colorscheme, priority 1000, transparent mode |
| `xiyaowong/transparent.nvim` | Global transparent background |
| `folke/snacks.nvim` | Dashboard, file explorer, picker, notifications, indent guides, terminal, scroll animation, statuscolumn, word highlighting |
| `nvim-lualine/lualine.nvim` | Statusline, gruvbox-material theme |
| `akinsho/bufferline.nvim` | Buffer tabs, custom filter for log files |
| `folke/which-key.nvim` | Keymap discovery, classic preset, double border |
| `folke/todo-comments.nvim` | TODO/FIXME/NOTE/HACK highlights |
| `HiPhish/rainbow-delimiters.nvim` | Colorful bracket matching |

### LSP & Completion (`plugins/lsp.lua`)
| Plugin | Purpose |
|--------|---------|
| `williamboman/mason.nvim` | LSP/tool installer |
| `williamboman/mason-lspconfig.nvim` | Mason ↔ lspconfig bridge |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | Auto-install formatters: stylua, rubocop, erb-lint |
| `neovim/nvim-lspconfig` | Server configs (ruby_lsp, lua_ls); typescript-tools handles TS |
| `pmizio/typescript-tools.nvim` | Direct tsserver communication, replaces ts_ls (faster) |
| `folke/lazydev.nvim` | Lua LSP completions for neovim config files |
| `saghen/blink.cmp` | Completion engine — LSP, buffer, path, snippets. Tab=confirm top, C-n/C-p=navigate |
| `stevearc/conform.nvim` | Formatting: stylua (Lua), rubocop (Ruby), erb-lint (ERB). Manual via `<leader>lf` |

**LSP config pattern:** Neovim 0.11 native `vim.lsp.config` used where possible. Mason handles installation; lspconfig provides server metadata.

**Installed language servers:** `ruby_lsp`, `lua_ls`  
**TypeScript:** handled by `typescript-tools.nvim` directly (no ts_ls)  
**Formatters/linters:** `stylua`, `rubocop`, `erb-lint`

### AI (`plugins/ai.lua`)
| Plugin | Purpose |
|--------|---------|
| `olimorris/codecompanion.nvim` | AI coding assistant, Anthropic/Claude provider |
| `supermaven-inc/supermaven-nvim` | Ghost text inline completions, Tab=accept, C-]=clear |

**codecompanion provider:** Anthropic (Claude). Set via `ANTHROPIC_API_KEY` env var.

**Claude Code tool:** Built into codecompanion — use `/claude-code` inside a chat buffer to invoke Claude Code CLI as an agent. It can read files, run commands, and make edits while streaming output into the chat.

### Git (`plugins/git.lua`)
| Plugin | Purpose |
|--------|---------|
| `lewis6991/gitsigns.nvim` | Inline hunk signs, blame line, stage/reset hunks |
| `kdheepak/lazygit.nvim` | LazyGit TUI via `<leader>gg` |
| `sindrets/diffview.nvim` | Multi-file diffs, merge conflict resolution, file history |

### Editor (`plugins/editor.lua`)
| Plugin | Purpose |
|--------|---------|
| `echasnovski/mini.ai` | Enhanced textobjects (around/inside functions, classes, etc.) |
| `echasnovski/mini.surround` | Add/delete/replace surrounding brackets/quotes |
| `echasnovski/mini.pairs` | Auto-close brackets and quotes |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting, auto-install parsers |
| `nvim-treesitter/nvim-treesitter-context` | Sticky function/class context header (max 5 lines) |

### Rails (`plugins/rails.lua`)
| Plugin | Purpose |
|--------|---------|
| `tpope/vim-rails` | Full Rails navigation: models, controllers, views, specs, migrations, fixtures, locales |

### Dropped from old config
`nvim-cmp`, `luasnip`, `friendly-snippets`, `nvim-tree`, `copilotchat`, `indent-blankline`, `statuscol`, `toggleterm`, `persistence.nvim`, `mini.diff`, `mini.files`, `mini.starter`, `fidget.nvim`, `nvim-treesitter-endwise`, `vim-sleuth`, `lspconfig` legacy API patterns, old incomplete codecompanion setup

---

## Keymaps

**Leader:** `<Space>`

### Preserved exactly
| Key | Action |
|-----|--------|
| `C-h/j/k/l` | Window navigation |
| `S-h` / `S-l` | Previous / next buffer |
| `A-j/k` | Move line/block up/down (normal + visual) |
| `C-Up/Down/Left/Right` | Resize splits |
| `gd/gD/gh/gI/gr/gt` | LSP go-to definition/declaration/hover/implementation/references/type |
| `]/[q` | Quickfix next/prev |
| `<leader>w/q/c` | Save / quit / close buffer |
| `<leader>b*` | Buffer group (jump, find, prev, next, close, sort) |
| `<leader>g*` | Git group (lazygit, hunks, blame, stage, reset) |
| `<leader>l*` | LSP group (actions, diagnostics, format, rename, symbols) |
| `<leader>r*` | Rails group (alternate, model, controller, view, spec, migration, etc.) |
| `<leader>p*` | Plugin management (lazy install/sync/update/clean) |
| `Esc Esc` | Exit terminal mode |

### Updated (same key, new plugin)
| Key | Old | New |
|-----|-----|-----|
| `<leader>e` | mini.files | snacks explorer |
| `<leader>f` | telescope find_files | snacks picker find_files |
| `<leader>s*` | telescope pickers | snacks picker equivalents |
| `<C-\>` | toggleterm | snacks terminal |

### New
| Key | Action |
|-----|--------|
| `<leader>ac` | CodeCompanion chat toggle |
| `<leader>ai` | CodeCompanion inline assist |
| `<leader>aa` | CodeCompanion action palette |
| `<leader>gd` | Diffview open |
| `<leader>gh` | Diffview file history |
| `]d` / `[d` | Diagnostic next/prev (replaces `<leader>lj/lk`) |

---

## Editor Behavior (unchanged)
- 2-space indent, spaces not tabs
- No format-on-save (manual `<leader>lf`)
- No swap/backup files, undo persistence on
- Transparent background
- Scroll offset: 10 lines
- Whitespace visualization (tabs + trailing)
- OS clipboard sync
- Relative + absolute line numbers
- Splits: right and below

---

## Pre-flight
1. Back up `~/.config/nvim/` → `~/.config/nvim.bak/`
2. Wipe `~/.config/nvim/` (keep `.git/`)
3. Build new structure from scratch
