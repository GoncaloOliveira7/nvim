vim.pack.add {
  -- Main LSP Configuration
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/pmizio/typescript-tools.nvim',
}

require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local builtin = require 'telescope.builtin'

    -- Jump to the definition of the word under your cursor. To jump back, press <C-t>.
    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    -- WARN: This is not Goto Definition, this is Goto Declaration.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- typescript-tools only commands, mapped only in buffers where it is attached
    if client and client.name == 'typescript-tools' then
      map('<leader>cr', '<cmd>TSToolsRemoveUnusedImports<CR>', 'Remove Unused Imports')
      map('<leader>co', '<cmd>TSToolsOrganizeImports<CR>', 'Organize Imports')
    end

    -- Highlight references of the word under the cursor when it rests there for a while.
    -- See `:help CursorHold`
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Toggle inlay hints, if the language server supports them
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- NOTE: Completion capabilities are added by blink.cmp itself via `vim.lsp.config('*', ...)`
-- (see blink.cmp/plugin/blink-cmp.lua), so they are not set here.

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

-- Language servers and their config overrides.
-- Each entry is passed to `vim.lsp.config(name, cfg)` and merged with nvim-lspconfig's defaults.
-- Servers are installed by mason-tool-installer and enabled by mason-lspconfig (`automatic_enable`).
-- See `:help lspconfig-all` for the list of available servers.
local servers = {
  bashls = {},
  taplo = {},
  terraformls = {},
  tflint = {},
  gitlab_ci_ls = {},
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  },
  markdown_oxide = {
    -- dynamicRegistration lets the server react to actions like "Create Unresolved File"
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        customTags = {
          '!Equals sequence',
          '!FindInMap sequence',
          '!GetAtt',
          '!GetAZs',
          '!ImportValue',
          '!Join sequence',
          '!Ref',
          '!Select sequence',
          '!Split sequence',
          '!Sub',
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
}

-- Non-LSP tools (formatters, linters) that Mason should install
local tools = {
  'isort',
  'prettierd',
  'eslint_d',
  'yamllint',
  'gdtoolkit',
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
end

vim.filetype.add {
  pattern = {
    ['.*%.gitlab%-ci.*%.ya?ml'] = 'yaml.gitlab',
  },
}

-- Ensure the servers and tools above are installed. See `:Mason` (press `g?` for help).
require('mason').setup()

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, tools)
require('mason-tool-installer').setup {
  ensure_installed = ensure_installed,
  auto_update = true,
}

-- mason-lspconfig v2: enables every Mason-installed server via `vim.lsp.enable()`.
-- ts_ls is excluded because typescript-tools.nvim provides its own client.
require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_enable = {
    exclude = { 'ts_ls' },
  },
}
