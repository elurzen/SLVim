-- Set leader key before anything else
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local config = vim.fn.stdpath('config')
package.path = config .. '/?.lua;' .. config .. '/?/init.lua;'


local modules = {
  'vanzencfg.nvim_options',
  'vanzencfg.keybinds',
  'vanzencfg.plugin_manager',
  'vanzencfg.autocmds'
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify('Failed to load ' .. module .. ': ' .. err, vim.log.levels.ERROR)
  end
end

-- Load core editor options
--require 'vanzencfg.nvim_options'

-- Load keybindings (global/editor UX bindings only)
--require 'vanzencfg.keybinds'

-- Load and configure all plugins
--require 'vanzencfg.plugin_manager'

-- Load autocommands
--require 'vanzencfg.autocmds'
