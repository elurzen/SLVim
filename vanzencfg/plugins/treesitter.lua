-- Highlight, edit, and navigate code.
--
-- nvim-treesitter `main` branch: a full, incompatible rewrite of the plugin.
-- It no longer ships the `nvim-treesitter.configs` module or the
-- highlight/indent/selection *modules*; it only installs parsers and ships
-- the query files. Features are enabled through Neovim's built-in treesitter
-- APIs (`vim.treesitter.start()`, native injections, etc.).
--
-- Requires: Neovim >= 0.12, `tree-sitter-cli` (parsers are compiled via
-- `tree-sitter build`) and a C compiler.
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- `main` does not support lazy-loading and recompiles parsers on update.
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Parsers we always want available. (`main` has no `ensure_installed`/
      -- `auto_install`; this call is idempotent and runs asynchronously.)
      require('nvim-treesitter').install {
        'bash',
        'c',
        'c_sharp',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'yaml',
      }

      -- Enable highlighting + indentation per buffer. Highlighting is provided
      -- by Neovim itself; `vim.treesitter.start()` errors when no parser is
      -- installed for the filetype, so guard it and only wire indent on success.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('vanzen_treesitter', { clear = true }),
        callback = function(ev)
          if not pcall(vim.treesitter.start, ev.buf) then
            return
          end
          -- Treesitter indentation is provided by the plugin (experimental).
          -- Ruby relies on vim's regex indent, so leave it alone.
          if vim.bo[ev.buf].filetype ~= 'ruby' then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
