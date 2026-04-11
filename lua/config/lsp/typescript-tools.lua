require('typescript-tools').setup {
  settings = {
    tsserver_plugins = {
      '@styled/typescript-styled-plugin',
    },
    tsserver_format_options = function()
      return {
        tabSize = 2,
        indentSize = 2,
      }
    end,
  },
}
