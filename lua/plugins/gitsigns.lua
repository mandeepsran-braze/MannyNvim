local M = {}

M.config = {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

M.setup = function()
  require('gitsigns').setup(M.config)
end

return M

-- vim: ts=2 sts=2 sw=2 et
