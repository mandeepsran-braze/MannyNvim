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
