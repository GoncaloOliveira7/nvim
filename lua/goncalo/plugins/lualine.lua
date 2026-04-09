return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      winbar = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_z = { 'location' },
      },
      extensions = { 'oil' },
      sections = {
        -- Add the macro recording status in the mode section
        lualine_a = {
          function()
            local reg = vim.fn.reg_recording()
            -- If a macro is being recorded, show "Recording @<register>"
            if reg ~= '' then
              return 'Recording @' .. reg
            end
            return ''
          end,
        },
        lualine_b = {
          {
            require('noice').api.status.message.get_hl,
            cond = require('noice').api.status.message.has,
          },
        },
        lualine_c = {},
        lualine_d = {},
        lualine_x = {},
        lualine_z = {},
      },
      options = {
        theme = 'onedark',
      },
    }
  end,
}
