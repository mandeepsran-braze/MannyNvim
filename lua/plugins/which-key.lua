local M = {}

M.config = {
  require('which-key').setup {
    window = {
      border = 'double', -- none, single, double, shadow
      position = 'bottom', -- bottom, top
      margin = { 1, 2, 1, 2 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 1,
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 10, -- spacing between columns
      align = 'left', -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
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
    w = { '<cmd>w!<CR>', 'Save' },
    q = { '<cmd>confirm q<CR>', 'Quit' },
    c = { '<cmd>BufferKill<CR>', 'Close Buffer' },
    e = { '<cmd>NvimTreeToggle<CR>', 'Explorer' },
    f = {
      function()
        require('telescope.builtin').find_files()
      end,
      'Find file',
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
          }
        end,
        'Find Text in Open Files',
      },
      b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
      c = { '<cmd>Telescope colorscheme<cr>', 'Colorscheme' },
      f = { '<cmd>Telescope find_files<cr>', 'Find File' },
      r = { '<cmd>Telescope oldfiles<cr>', 'Open Recent File' },
      t = { '<cmd>Telescope live_grep<cr>', 'Find Text' },
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

  local g_options = {
    mode = 'n', -- NORMAL mode
    prefix = 'g',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }

  local g_mappings = {
    d = { '<cmd>Telescope lsp_definitions<cr>', 'Go-to Definition' },
    D = { '<cmd>lua vim.lsp.buf.declaration<cr>', 'Go-to Declaration' },
    h = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Go-to Hover' },
    I = { '<cmd>Telescope lsp_implementations<cr>', 'Go-to Implementation' },
    r = { '<cmd>Telescope lsp_references<cr>', 'Go-to References' },
    t = { '<cmd>Telescope lsp_type_definitions<cr>', 'Go-to Type Definition' },
  }

  -- Register keys
  require('which-key').register(leader_mappings, leader_options)
  require('which-key').register(g_mappings, g_options)
end

return M

-- vim: ts=2 sts=2 sw=2 et
