vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
}

require('treesitter-context').setup {
  multiline_threshold = 1,
}

-- NOTE: On the `main` branch, `require('nvim-treesitter').setup()` only accepts `install_dir`.
-- Highlighting, indentation and auto-install for other filetypes are handled by
-- config/autocmds/treesitter-autocmd.lua. Incremental selection no longer exists in nvim-treesitter.
local ensure_installed = {
  'bash',
  'c',
  'c_sharp',
  'cmake',
  'comment',
  'css',
  'csv',
  'dockerfile',
  'dot',
  'gdscript',
  'gdshader',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'goctl',
  'godot_resource',
  'gomod',
  'gosum',
  'gotmpl',
  'gowork',
  'gpg',
  'graphql',
  'hcl',
  'html',
  'http',
  'java',
  'javascript',
  'json',
  'luadoc',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'nginx',
  'ninja',
  'python',
  'regex',
  'ruby',
  'rust',
  'scss',
  'sql',
  'ssh_config',
  'terraform',
  'tsx',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

-- Only kick off an (async) install for parsers that are missing
local installed = require('nvim-treesitter').get_installed 'parsers'
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ensure_installed)
if #missing > 0 then
  require('nvim-treesitter').install(missing)
end

-- [[ Textobjects ]]
-- See `:help nvim-treesitter-textobjects`
require('nvim-treesitter-textobjects').setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'v', -- charwise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- Extend textobjects to include preceding or succeeding whitespace (like the built-in `ap`)
    include_surrounding_whitespace = true,
  },
}

local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
local textobjects = {
  af = { '@function.outer', 'textobjects', 'Around function' },
  ['if'] = { '@function.inner', 'textobjects', 'Inside function' },
  ac = { '@class.outer', 'textobjects', 'Around class' },
  ic = { '@class.inner', 'textobjects', 'Inside class' },
  as = { '@local.scope', 'locals', 'Around language scope' },
}
for keys, spec in pairs(textobjects) do
  local query, group, desc = spec[1], spec[2], spec[3]
  vim.keymap.set({ 'x', 'o' }, keys, function()
    select_textobject(query, group)
  end, { desc = desc })
end
