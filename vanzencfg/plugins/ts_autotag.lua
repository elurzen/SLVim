-- Autopair for html tags
return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'xml' },
    opts = {
      -- you can omit; these are defaults
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
