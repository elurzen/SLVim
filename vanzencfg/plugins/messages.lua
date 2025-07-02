--Floating message buffer
return {
  {
    'AckslD/messages.nvim',
    config = function()
      require('messages').setup()

      vim.api.nvim_create_user_command('Msgs', function()
        require('messages').show()
      end, {})

      -- Keymap <leader>m to show messages
      vim.keymap.set('n', '<leader>mm', function()
        vim.cmd 'Messages messages'
      end, { desc = 'Show Messages Float' })
    end,
  },
}
