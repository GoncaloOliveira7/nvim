vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

require('which-key').setup {
  preset = 'helix',
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>d', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>x', group = 'Diagnostics' },
    { '<leader>a', group = 'H[a]rpoon' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gs', group = '[S]urround', mode = { 'n', 'x' } },
  },
}

-- "p" makes sense: gv selects the last Visual selection, so this one selects the last pasted text.
vim.keymap.set('n', 'gp', function()
  vim.api.nvim_feedkeys('`[' .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. '`]', 'n', false)
end, { desc = 'Switch to VISUAL using last paste/change' })
