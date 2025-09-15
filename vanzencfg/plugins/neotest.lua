-- Neotest
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
      'nsidorenco/neotest-vstest',
    },
    keys = function()
      local function nmap(lhs, rhs, desc)
        return { lhs, rhs, desc = desc, mode = 'n', silent = true }
      end
      return {
        nmap('<leader>nn', function()
          require('neotest').run.run()
        end, 'Neotest: Run nearest'),
        nmap('<leader>nf', function()
          require('neotest').run.run(vim.fn.expand '%')
        end, 'Neotest: Run file'),
        nmap('<leader>nF', function()
          require('neotest').run.run(vim.loop.cwd())
        end, 'Neotest: Run project'),
        nmap('<leader>nl', function()
          require('neotest').run.run_last()
        end, 'Neotest: Run last'),
        nmap('<leader>ns', function()
          require('neotest').summary.toggle()
        end, 'Neotest: Toggle summary'),
        nmap('<leader>no', function()
          require('neotest').output.open { enter = true }
        end, 'Neotest: Output (float)'),
        nmap('<leader>nO', function()
          require('neotest').output_panel.toggle()
        end, 'Neotest: Output panel'),
        nmap('<leader>na', function()
          require('neotest').run.attach()
        end, 'Neotest: Attach'),
        nmap('<leader>nw', function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end, 'Neotest: Watch file'),
        nmap('<leader>nW', function()
          require('neotest').watch.toggle()
        end, 'Neotest: Watch nearest'),
        nmap('<leader>n]', function()
          require('neotest').jump.next { status = 'failed' }
        end, 'Neotest: Next failed'),
        nmap('<leader>n[', function()
          require('neotest').jump.prev { status = 'failed' }
        end, 'Neotest: Prev failed'),
        -- Optional DAP:
        nmap('<leader>nd', function()
          require('neotest').run.run { strategy = 'dap' }
        end, 'Neotest: Debug nearest'),
        nmap('<leader>nD', function()
          require('neotest').run.run_last { strategy = 'dap' }
        end, 'Neotest: Debug last'),
      }
    end,
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-vitest',
          require 'neotest-vstest',
        },
      }
    end,
  },
}
