return {
  'ThePrimeagen/harpoon',
  branch = 'master',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu, { desc = 'Harpoon Quick Menu' })

    vim.keymap.set('n', '<leader>a1', function()
      mark.set_current_at(1)
    end,
    { desc = 'Harpoon Add File 1' })
    vim.keymap.set('n', '<leader>a2', function()
      mark.set_current_at(2)
    end,
    { desc = 'Harpoon Add File 2' })
    vim.keymap.set('n', '<leader>a3', function()
      mark.set_current_at(3)
    end,
    { desc = 'Harpoon Add File 3' })
    vim.keymap.set('n', '<leader>a4', function()
      mark.set_current_at(4)
    end,
    { desc = 'Harpoon Add File 4' })

    vim.keymap.set('n', '<leader>1', function()
      ui.nav_file(1)
    end,
    { desc = 'Harpoon Jump to 1' })
    vim.keymap.set('n', '<leader>2', function()
      ui.nav_file(2)
    end,
    { desc = 'Harpoon Jump to 2' })
    vim.keymap.set('n', '<leader>3', function()
      ui.nav_file(3)
    end,
    { desc = 'Harpoon Jump to 3' })
    vim.keymap.set('n', '<leader>4', function()
      ui.nav_file(4)
    end,
    { desc = 'Harpoon Jump to 4' })
  end,
}