vim.api.nvim_set_hl(0, 'SkullRed', { fg = '#ffffff' })
local header_art = {
  '                          .                                                      .                          ',
  '                        .n                   .                 .                  n.                        ',
  '                  .   .dP                  dP                   9b                 9b.    .                  ',
  '                 4    qXb         .       dX                     Xb       .        dXp     t                 ',
  '                dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb                ',
  '                9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP                ',
  '                 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP                 ',
  "                  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'                  ",
  "                    `9XXXXXXXXXXXP' `9XX'          `98v8P'          `XXP' `9XXXXXXXXXXXP'                    ",
  '                        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~                        ',
  "                                        )b.  .dbo.dP'`v'`9b.odb.  .dX(                                        ",
  '                                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.                                      ',
  "                                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb                                     ",
  '                                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb                                    ',
  "                                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP                                    ",
  "                                     `'      9XXXXXX(   )XXXXXXP      `'                                     ",
  "                                              XXXX X.`v'.X XXXX                                              ",
  "                                              XP^X'`b   d'`X^XX                                              ",
  "                                              X. 9  `   '  P )X                                              ",
  "                                              `b  `       '  d'                                              ",
  "                                               `             '                                               ",
  '',
}
--Startup Screen
return {
  {
    'startup-nvim/startup.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('startup').setup {
        header = {
          type = 'text',
          align = 'center',
          fold_section = false,
          title = 'Header',
          margin = 5,
          content = header_art,
          highlight = 'SkullRed',
        },
        body = {
          type = 'mapping',
          align = 'center',
          fold_section = false,
          title = 'Basic Commands',
          margin = 5,
          content = {
            { ' Find File', 'Telescope find_files', '<leader>ff' },
            { ' Find Word', 'Telescope live_grep', '<leader>fg' },
            { '󰪶 Recent Files', 'Telescope oldfiles', '<leader>fo' },
            { ' New File', 'enew', '<leader>fn' },
            { ' Quit', 'qa', '<leader>q' },
          },
          highlight = 'SkullRed',
        },
        options = {
          mapping_keys = true,
          cursor_column = 0.5,
          empty_lines_between_mappings = true,
          disable_statuslines = true,
          paddings = { 1, 1, 1, 1 },
        },
        mappings = {
          execute_command = '<CR>',
          open_file = 'o',
          open_file_split = '<c-o>',
          open_section = '<TAB>',
          open_help = '?',
        },
        parts = { 'header', 'body' },
      }
    end,
  },
}
