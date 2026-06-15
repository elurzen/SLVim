--Navigation aid: press s or S to start it, type 2 characters of where you want to go, then the trigger key
return {
  {
    -- Repo moved from GitHub (ggandor/leap.nvim) to Codeberg.
    url = 'https://codeberg.org/andyg/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      require 'leap' --.add_default_mappings()

      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', '<Plug>(leap-backward)')
    end,
  },
}
