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
