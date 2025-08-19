local icons = require 'icons'
local M = {}

M.config = {
  disable_netrw = false,
  hijack_netrw = true,
  sort_by = 'name',
  sync_root_with_cwd = true,
  view = {
    width = 100,
    side = 'left',
    number = true,
    relativenumber = true,
    signcolumn = 'yes',
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = true,
    full_name = false,
    highlight_opened_files = 'all',
    root_folder_label = ':t',
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = '└',
        edge = '│',
        item = '│',
        none = ' ',
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = 'before',
      padding = ' ',
      symlink_arrow = ' ➛ ',
      show = {
        file = true,
        folder = true,
        folder_arrow = false,
        git = true,
      },
      glyphs = {
        default = icons.ui.Text,
        symlink = icons.ui.FileSymlink,
        bookmark = icons.ui.BookMark,
        folder = {
          arrow_closed = icons.ui.TriangleShortArrowRight,
          arrow_open = icons.ui.TriangleShortArrowDown,
          default = icons.ui.Folder,
          open = icons.ui.FolderOpen,
          empty = icons.ui.EmptyFolder,
          empty_open = icons.ui.EmptyFolderOpen,
          symlink = icons.ui.FolderSymlink,
          symlink_open = icons.ui.FolderOpen,
        },
        git = {
          unstaged = icons.git.FileUnstaged,
          staged = icons.git.FileStaged,
          unmerged = icons.git.FileUnmerged,
          renamed = icons.git.FileRenamed,
          untracked = icons.git.FileUntracked,
          deleted = icons.git.FileDeleted,
          ignored = icons.git.FileIgnored,
        },
      },
    },
    special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
    symlink_destination = true,
  },
  hijack_directories = {
    enable = false,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    debounce_delay = 15,
    update_root = true,
    ignore_list = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = icons.diagnostics.BoldHint,
      info = icons.diagnostics.BoldInformation,
      warning = icons.diagnostics.BoldWarning,
      error = icons.diagnostics.BoldError,
    },
  },
  filters = {
    custom = { 'node_modules', '\\.cache' },
  },
  filesystem_watchers = {
    debounce_delay = 50,
  },
  git = {
    timeout = 200,
  },
  actions = {
    expand_all = {
      max_folder_discovery = 300,
    },
    open_file = {
      window_picker = {
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
        exclude = {
          filetype = { 'notify', 'lazy', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
          buftype = { 'nofile', 'terminal', 'help' },
        },
      },
    },
  },
}

local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  local useful_keys = {
    ['l'] = { api.node.open.edit, opts 'Open' },
    ['o'] = { api.node.open.edit, opts 'Open' },
    ['<CR>'] = { api.node.open.edit, opts 'Open' },
    ['v'] = { api.node.open.vertical, opts 'Open: Vertical Split' },
    ['h'] = { api.node.navigate.parent_close, opts 'Close Directory' },
    ['C'] = { api.tree.change_root_to_node, opts 'CD' },
  }

  require('keymaps').load_mode('n', useful_keys)
end

M.setup = function()
  M.config.on_attach = on_attach
  require('nvim-tree').setup(M.config)
end

return M

-- vim: ts=2 sts=2 sw=2 et
