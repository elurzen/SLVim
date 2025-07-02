--tokyonight theme for nvim
return {
  {
    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      --Function to toggle nvim transparency
      local tokyonight_transparent = false
      local function toggle_tokyonight_transparency()
        tokyonight_transparent = not tokyonight_transparent
        require('tokyonight').setup {
          style = 'night', -- or your preferred variant
          transparent = tokyonight_transparent,
          styles = {
            comments = { italic = false },
            keywords = { italic = true },
            functions = { italic = false },
            variables = { italic = false },
            types = { italic = true },
            conditionals = { italic = false },
            constants = { italic = false },
            operators = { italic = false },
            strings = { italic = false },
            sidebars = tokyonight_transparent and 'transparent' or 'dark',
            floats = tokyonight_transparent and 'transparent' or 'dark',
          },
        }
        vim.cmd 'colorscheme tokyonight-night'
        print('Tokyo Night Transparency: ' .. (tokyonight_transparent and 'ON' or 'OFF'))
      end

      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = true,
        styles = {
          comments = { italic = false }, -- Disable italics in comments
          sidebars = 'transparent',
          floats = 'transparent',
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
      vim.keymap.set('n', '<leader>`t', toggle_tokyonight_transparency, { desc = 'Toggle Tokyo Night transparency' })
    end,
  },
}
