-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- This uses tabs
-- vim.o.tabstop = 4
-- vim.o.shiftwidth = 4

--This uses 2 spaces as a tab
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Windows only: drive `:!`, `:terminal`, system() through PowerShell.
-- On WSL/Linux there is no `powershell` on PATH, so leave the default ($SHELL),
-- otherwise every shell-out (terminal, formatters, git helpers) would break.
if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'powershell'
  vim.o.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

-- WSL has no native clipboard tool, so bridge to the Windows clipboard via
-- win32yank (in ~/.local/bin, on PATH). It does both copy and paste, is UTF-8
-- clean, and avoids OSC 52 (which intermittently freezes tmux's single-threaded
-- server while Windows Terminal acquires the clipboard lock) as well as the
-- PowerShell startup latency the old clip.exe + Get-Clipboard pair paid on every
-- paste. --crlf normalizes LF->CRLF going out, --lf strips CRLF->LF coming back.
-- cache_enabled=0 so paste always reads the live Windows clipboard. Drives the
-- explicit "+ mappings (<leader>y / <leader>yy / <leader>p); plain y stays local.
if vim.fn.has 'wsl' == 1 and vim.fn.executable 'win32yank.exe' == 1 then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = { ['+'] = 'win32yank.exe -i --crlf', ['*'] = 'win32yank.exe -i --crlf' },
    paste = { ['+'] = 'win32yank.exe -o --lf', ['*'] = 'win32yank.exe -o --lf' },
    cache_enabled = 0,
  }
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
