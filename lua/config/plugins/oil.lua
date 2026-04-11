vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require('oil').setup {
  columns = { 'icon' },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-k>'] = false,
    ['<C-j>'] = false,
    ['<C-s>'] = false,
    -- ['<M-h>'] = 'actions.select_split',
  },
  view_options = {
    show_hidden = true,
  },
}

-- Open parent directory in current window
vim.keymap.set('n', '\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '§', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
