return {
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
      local keys = {
        {
          '<leader>ha',
          function()
            require('harpoon.mark').add_file()
          end,
          desc = 'Harpoon: Add file',
        },
        {
          '<leader>hm',
          function()
            require('harpoon.ui').toggle_quick_menu()
          end,
          desc = 'Harpoon: Toggle menu',
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          '<leader>h' .. i,
          function()
            require('harpoon.ui').nav_file(i)
          end,
          desc = 'Harpoon: Go to file ' .. i,
        })
      end

      return keys
    end,
    config = function()
      require('harpoon').setup()
    end,
  },
}
