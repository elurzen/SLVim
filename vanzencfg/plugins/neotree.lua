-- Neotree File tree: shows file tree window
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      { '<leader>tc', '<cmd>Neotree toggle left reveal_force_cwd<cr>', desc = 'NeoTree: Toggle at cwd (left)' },
      { '<leader>tf', '<cmd>Neotree toggle current reveal_force_cwd<cr>', desc = 'NeoTree: Toggle at cwd in current window' },
      { '<leader>tt', '<cmd>Neotree close<cr>', desc = 'NeoTree: Close window' },
    },
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
      -- fill any relevant options here
      filesystem = {
        filtered_items = {
          visible = false, -- Shows hidden files normally (not dimmed)
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
    },
  },
}
