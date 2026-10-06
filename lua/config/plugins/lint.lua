vim.pack.add {
  'https://github.com/mfussenegger/nvim-lint',
}

local lint = require 'lint'

-- Lets eslint_d shut down when this Neovim instance exits
vim.env.ESLINT_D_PPID = vim.fn.getpid()

-- NOTE: terraform/tflint is handled by the tflint language server (see lsp-config.lua)
lint.linters_by_ft = {
  -- markdown = { 'markdownlint' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  -- svelte = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
