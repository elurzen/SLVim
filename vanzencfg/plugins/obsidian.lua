-- obsidian.nvim — navigate the tome vault like Obsidian, in the terminal.
-- Follow [[wikilinks]] with `gf` (works out of the box via includeexpr),
-- jump/search/backlinks via telescope, `[[` autocompletes note names via blink.
-- Rendering is left to render-markdown.nvim (ui.enable = false) to avoid conflicts.
return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- latest release
    ft = 'markdown',
    cmd = 'Obsidian',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ww', '<cmd>edit ~/tome/TODO.md<cr>', desc = 'Wiki: open tome (TODO)' },
      { '<leader>wo', '<cmd>Obsidian quick_switch<cr>', desc = 'Wiki: open/jump to note' },
      { '<leader>ws', '<cmd>Obsidian search<cr>', desc = 'Wiki: search (grep)' },
      { '<leader>wb', '<cmd>Obsidian backlinks<cr>', desc = 'Wiki: backlinks' },
      { '<leader>wt', '<cmd>Obsidian tags<cr>', desc = 'Wiki: tags' },
      { '<leader>wn', '<cmd>Obsidian new<cr>', desc = 'Wiki: new note' },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- use the modern `:Obsidian <subcommand>` interface
      workspaces = {
        { name = 'tome', path = '~/tome' },
      },
      -- New notes are created under tome/notes/ as kebab-case .md files.
      notes_subdir = 'notes',
      new_notes_location = 'notes_subdir',
      -- Keep [[wiki]]-style links, shortest form, matching the tome convention.
      link = {
        style = 'wiki',
        format = 'shortest',
      },
      -- Completion (`[[` for links, `#` for tags) is provided automatically by
      -- obsidian.nvim's built-in in-process LSP; blink.cmp surfaces it. No config needed.
      -- telescope.nvim drives quick_switch / search / backlinks pickers.
      picker = {
        name = 'telescope.nvim',
      },
      -- <CR> on a checkbox just toggles unchecked <-> done (no extra states).
      checkbox = { order = { ' ', 'x' } },
      -- Let render-markdown.nvim handle in-buffer rendering everywhere, the
      -- vault included; disable obsidian's built-in UI so the two don't conflict.
      ui = { enable = false },
    },
  },
}
