-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

local plugins = {}

local plugin_files = {
  'guess_indent',
  'harpoon',
  'autopairs',
  'ts_autotag',
  'vim_fugitive',
  'code_companion',
  'leap',
  'ufo',
  'markdown',
  'neotest',
  'gitsigns',
  'messages',
  'auto_session',
  'omnisharp_extended_lsp',
  'lazydev',
  'nvim_dap_Csharp_CONSOLE',
  'indent_blankline',
  'which_key',
  'telescope',
  'lspconfig',
  'conform',
  'blink',
  'tokyonight',
  'todo_comments',
  'mini',
  'treesitter',
  'neotree',
  'startup',
}

-- Load each plugin file and merge into the plugins table
for _, plugin_file in ipairs(plugin_files) do
  local ok, plugin_config = pcall(require, 'vanzencfg.plugins.' .. plugin_file)
  if ok then
    if type(plugin_config) == 'table' then
      -- If it's a table, merge it
      vim.list_extend(plugins, plugin_config)
    end
  else
    vim.notify('Failed to load plugin: ' .. plugin_file, vim.log.levels.WARN)
  end
end

local lazy_opts = {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

require('lazy').setup(plugins, lazy_opts)
