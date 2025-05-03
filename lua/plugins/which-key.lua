local M = {}

M.config = {
  require('which-key').setup {
    preset = 'classic',
    win = {
      -- don't allow the popup to overlap with the cursor
      no_overlap = true,
      height = { min = 4, max = 25 },
      col = 0,
      row = math.huge,
      border = 'double',
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = true,
      title_pos = 'center',
      zindex = 1000,
    },
    layout = {
      width = { min = 40 }, -- min and max width of the columns
      spacing = 5, -- spacing between columns
    },
    filter = function(mapping)
      -- example to exclude mappings without a description
      return mapping.desc and mapping.desc ~= ''
    end,
    notify = false,
    icons = {
      breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
      separator = '➜', -- symbol used between a key and it's label
      group = '+', -- symbol prepended to a group
      ellipsis = '…',
      -- set to false to disable all mapping icons,
      -- both those explicitely added in a mapping
      -- and those from rules
      mappings = true,
      --- See `lua/which-key/icons.lua` for more details
      --- Set to `false` to disable keymap icons from rules
      ---@type wk.IconRule[]|false
      rules = {},
      -- use the highlights from mini.icons
      -- When `false`, it will use `WhichKeyIcon` instead
      colors = true,
      -- used by key format
      keys = {
        Up = ' ',
        Down = ' ',
        Left = ' ',
        Right = ' ',
        C = '󰘴 ',
        M = '󰘵 ',
        D = '󰘳 ',
        S = '󰘶 ',
        CR = '󰌑 ',
        Esc = '󱊷 ',
        ScrollWheelDown = '󱕐 ',
        ScrollWheelUp = '󱕑 ',
        NL = '󰌑 ',
        BS = '<-',
        Space = '󱁐 ',
        Tab = '󰌒 ',
        F1 = '󱊫',
        F2 = '󱊬',
        F3 = '󱊭',
        F4 = '󱊮',
        F5 = '󱊯',
        F6 = '󱊰',
        F7 = '󱊱',
        F8 = '󱊲',
        F9 = '󱊳',
        F10 = '󱊴',
        F11 = '󱊵',
        F12 = '󱊶',
      },
    },
    show_help = true, -- show help message on the command line when the popup is visible
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
  },
}

M.setup = function()
  require('which-key').setup(M.config)
  local leader_options = {
    mode = 'n', -- NORMAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }
  local leader_mappings = {
    w = { '<cmd>w!<cr>', 'Save' },
    q = { '<cmd>confirm q<cr>', 'Quit' },
    c = { '<cmd>BufferKill<cr>', 'Close Buffer' },
    e = { '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>', 'Explorer' },
    f = {
      function()
        require('telescope.builtin').find_files {
          path_display = { 'truncate' },
        }
      end,
      'Find file',
    },
    a = {
      name = '(AI) CodeCompanion',
      c = { '<cmd>CodeCompanionChat<cr>', 'CodeCompanion Chat' },
      t = { '<cmd>CodeCompanionActions<cr>', 'CodeCompanion Action Palette' },
    },
    b = {
      name = 'Buffers',
      j = { '<cmd>BufferLinePick<cr>', 'Jump' },
      f = { '<cmd>Telescope buffers previewer=false<cr>', 'Find' },
      b = { '<cmd>BufferLineCyclePrev<cr>', 'Previous' },
      n = { '<cmd>BufferLineCycleNext<cr>', 'Next' },
      W = { '<cmd>noautocmd w<cr>', 'Save without formatting (noautocmd)' },
      e = {
        '<cmd>BufferLinePickClose<cr>',
        'Pick which buffer to close',
      },
      h = { '<cmd>BufferLineCloseLeft<cr>', 'Close all to the left' },
      l = {
        '<cmd>BufferLineCloseRight<cr>',
        'Close all to the right',
      },
      D = {
        '<cmd>BufferLineSortByDirectory<cr>',
        'Sort by directory',
      },
      L = {
        '<cmd>BufferLineSortByExtension<cr>',
        'Sort by language',
      },
    },
    g = {
      name = 'Git',
      g = { '<cmd>LazyGit<cr>', 'Lazygit' },
      j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", 'Next Hunk' },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", 'Prev Hunk' },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", 'Blame' },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", 'Stage Hunk' },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        'Undo Stage Hunk',
      },
      o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
      b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
      c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
      C = {
        '<cmd>Telescope git_bcommits<cr>',
        'Checkout commit(for current file)',
      },
      d = {
        '<cmd>Gitsigns diffthis HEAD<cr>',
        'Git Diff',
      },
    },
    p = {
      name = 'Plugins',
      i = { '<cmd>Lazy install<cr>', 'Install' },
      s = { '<cmd>Lazy sync<cr>', 'Sync' },
      S = { '<cmd>Lazy clear<cr>', 'Status' },
      c = { '<cmd>Lazy clean<cr>', 'Clean' },
      u = { '<cmd>Lazy update<cr>', 'Update' },
      p = { '<cmd>Lazy profile<cr>', 'Profile' },
      l = { '<cmd>Lazy log<cr>', 'Log' },
      d = { '<cmd>Lazy debug<cr>', 'Debug' },
    },
    l = {
      name = 'LSP',
      a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
      d = { '<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>', 'Buffer Diagnostics' },
      w = { '<cmd>Telescope diagnostics<cr>', 'Diagnostics' },
      f = {
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        'Format',
      },
      i = { '<cmd>LspInfo<cr>', 'Info' },
      I = { '<cmd>Mason<cr>', 'Mason Info' },
      j = {
        '<cmd>lua vim.diagnostic.goto_next()<cr>',
        'Next Diagnostic',
      },
      k = {
        '<cmd>lua vim.diagnostic.goto_prev()<cr>',
        'Prev Diagnostic',
      },
      l = { '<cmd>lua vim.lsp.codelens.run()<cr>', 'CodeLens Action' },
      q = { '<cmd>lua vim.diagnostic.setloclist()<cr>', 'Quickfix' },
      r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
      s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
      S = {
        '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
        'Workspace Symbols',
      },
      e = { '<cmd>Telescope quickfix<cr>', 'Telescope Quickfix' },
    },
    s = {
      name = 'Search',
      ['/'] = {
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
            path_display = { 'truncate' },
          }
        end,
        'Find Text in Open Files',
      },
      b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
      c = { '<cmd>Telescope colorscheme<cr>', 'Colorscheme' },
      f = { '<cmd>Telescope find_files<cr>', 'Find File' },
      r = {
        function()
          require('telescope.builtin').oldfiles {
            path_display = { 'truncate' },
          }
        end,
        'Open Recent File',
      },
      t = {
        function()
          require('telescope.builtin').live_grep {
            prompt_title = 'Live Grep',
            path_display = { 'truncate' },
          }
        end,
        'Find Text',
      },
      k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
      C = { '<cmd>Telescope commands<cr>', 'Commands' },
      l = { '<cmd>Telescope resume<cr>', 'Resume last search' },
      p = {
        "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
        'Colorscheme with Preview',
      },
      n = {
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.stdpath 'config',
          }
        end,
        'Search Nvim Config Files',
      },
    },
    T = {
      name = 'Treesitter',
      i = { ':TSConfigInfo<cr>', 'Info' },
    },
  }

  -- Register keys
  require('which-key').register(leader_mappings, leader_options)

  require('which-key').add {
    {
      mode = 'n',
      { 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'Go-to Definition' },
      { 'gD', '<cmd>lua vim.lsp.buf.declaration<cr>', desc = 'Go-to Declaration' },
      { 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', desc = 'Go-to Hover' },
      { 'gI', '<cmd>Telescope lsp_implementations<cr>', desc = 'Go-to Implementation' },
      { 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'Go-to References' },
      { 'gt', '<cmd>Telescope lsp_type_definitions<cr>', desc = 'Go-to Type Definition' },
    },
  }
end

return M

-- vim: ts=2 sts=2 sw=2 et
