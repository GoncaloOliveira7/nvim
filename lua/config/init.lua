require 'config.global-variables'

-- Must be registered before any `vim.pack.add` so build steps run on first install
require 'config.autocmds.pack-autocmd'

require 'config.themes'

require 'config.options'
require 'config.keymaps'
require 'config.diagnostics'
require 'config.plugins'
require 'config.autocmds'
