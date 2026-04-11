vim.pack.add {
  'https://github.com/ThePrimeagen/harpoon',
   'https://github.com/nvim-lua/plenary.nvim'}
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu, { desc = 'Harpoon Quick Menu' })

    for i = 1, 9 do
      vim.keymap.set('n', '<leader>a' .. i, function()
        mark.set_current_at(i)
      end, { desc = 'Harpoon Add File ' .. i })

      vim.keymap.set('n', '<leader>' .. i, function()
        ui.nav_file(i)
      end, { desc = 'Harpoon Jump to ' .. i })
    end
