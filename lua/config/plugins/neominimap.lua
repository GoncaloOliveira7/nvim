vim.pack.add { 'https://github.com/Isrothy/neominimap.nvim' }
-- Global Minimap Controls
vim.keymap.set('n', '<leader>tm', '<cmd>Neominimap toggle<cr>', { desc = 'Toggle global minimap' })

-- The following options are recommended when layout == "float"
vim.opt.wrap = false
vim.opt.sidescrolloff = 36 -- Set a large value

--- Put your configuration here
vim.g.neominimap = {
  auto_enable = true,
}
