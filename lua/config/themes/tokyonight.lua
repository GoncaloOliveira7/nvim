vim.pack.add { 'https://github.com/folke/tokyonight.nvim' }

-- Must go through setup(): a plain `:hi Comment` here would be wiped when the colorscheme loads
require('tokyonight').setup {
  styles = {
    comments = { italic = false },
  },
}
