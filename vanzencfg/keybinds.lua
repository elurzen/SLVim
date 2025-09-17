--=================================== Key Binds ===================================--

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Allows you to move the cursor using Ctrl+hjkl in insert mode
vim.keymap.set({ 'i' }, '<C-h>', '<Left>')
vim.keymap.set({ 'i' }, '<C-j>', '<Down>')
vim.keymap.set({ 'i' }, '<C-k>', '<Up>')
vim.keymap.set({ 'i' }, '<C-l>', '<Right>')

--Delete key functionality on C-l in insertmode
-- vim.keymap.set({ 'i' }, '<C-e>', '<Del>')
-- vim.keymap.set({ 'i' }, '<C-q>', '<BS>')

--Paste system clipboard: <leader>p
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste system clipboard below current line' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste system clipboard' })

--Copy to system clipboard
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })

--Scroll through Tabs Backwards (one of these can go when we figure out what we like)
vim.keymap.set('n', '<S-Tab>', '<C-PageUp>')

--Show Diagnostic Messages
--<leader>mm shows floating message box (configured in plugin)
vim.keymap.set('n', '<leader>md', '<cmd>lua vim.diagnostic.setloclist()<cr>', { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>mf', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = 'Open floating diagnostic window' })

-- vim.keymap.set('n', '<leader>`n', '<cmd>set rnu!<CR>', { desc = 'Toggle relative line numbers' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
