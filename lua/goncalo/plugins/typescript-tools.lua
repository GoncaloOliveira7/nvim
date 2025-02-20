return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    require('typescript-tools').setup {
      settings = {
        tsserver_plugins = {
          '@styled/typescript-styled-plugin',
        },
        tsserver_format_options = function(ft)
          return {
            tabSize = 2,
            indentSize = 2,
          }
        end,
      },
    }
  end,
}
