-- Autoformat
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

-- Format on save is handled by conform's `format_on_save` option below

vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

require('conform').setup {
  notify_on_error = true,
  notify_no_formatters = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 5000,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    python = { 'isort', 'black' },
    lua = { 'stylua' },
    javascript = { 'oxfmt' },
    typescript = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
    json = { 'oxfmt' },
    css = { 'oxfmt' },
    html = { 'oxfmt' },
    yaml = { 'oxfmt' },
    markdown = { 'oxfmt' },
    -- sh = { 'beautysh' },
    -- eruby = { 'erb_format' },
  },
}
