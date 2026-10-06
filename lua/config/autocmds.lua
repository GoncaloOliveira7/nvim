-- NOTE: config.autocmds.pack-autocmd is required early from config/init.lua
require 'config.autocmds.treesitter-autocmd'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
