--Recommended to have by DAP
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- optional: only load when editing Lua
    opts = {
      library = {
        -- add plugins here if you want extra API support
        -- auto-detects if using Lazy
        plugins = { 'nvim-dap-ui' },
        --for detcting lub API (for LSP)
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
