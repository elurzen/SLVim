--DAP (debugger) specifically for docker [WIP]
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      dap.set_log_level 'DEBUG'

      -- Setup UI
      dapui.setup()
      require('nvim-dap-virtual-text').setup {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = true, -- prefix virtual text with comment string
        only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        text_prefix = '',
        separator = ',',
        error_prefix = '  ',
        info_prefix = '  ',
        enable_commands = true,
        virt_lines_above = true,
        filter_references_pattern = '<module',
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param buf number
        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub('%s+', ' ')
          else
            return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }

      -- Auto open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- C# adapter config
      dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '\\mason\\packages\\netcoredbg\\netcoredbg\\netcoredbg.exe',
        args = { '--interpreter=vscode' },
        options = {
          detached = false,
        },
      }

      -- -- C# attach to netcoredbg
      -- dap.adapters.coreclr = {
      --   type = 'server',
      --   host = '127.0.0.1',
      --   port = 4711,
      -- }

      --Godot C# adapter config
      dap.adapters.godot_csharp = {
        type = 'server',
        host = '127.0.0.1',
        port = 6006,
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch .NET Core App',
          request = 'launch',
          program = function()
            -- Find .csproj file
            local project_file = vim.fn.glob(vim.fn.getcwd() .. '/*.csproj')
            if project_file == '' then
              error 'No .csproj file found in current directory!'
            end

            -- Build the project
            vim.fn.system { 'dotnet', 'build', project_file }

            -- Use dotnet CLI to figure out output path
            local dll_name = vim.fn.fnamemodify(project_file, ':t:r') .. '.dll'
            local dll_path = vim.fn.getcwd() .. '\\bin\\Debug\\net9.0\\' .. dll_name

            if vim.fn.filereadable(dll_path) == 0 then
              error('DLL not found: ' .. dll_path)
            end

            local build_output = vim.fn.system { 'dotnet', 'build', project_file }
            print(build_output)

            return dll_path
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = false,
          sourceFileMap = {
            [vim.fn.getcwd()] = vim.fn.getcwd(),
          },
          justMyCode = false,
          enableStepFiltering = false,
          -- Console configuration - output to DAP console in dapui
          console = 'console', -- Send output to DAP console window
          externalConsole = false, -- Don't create external console window
          internalConsoleOptions = 'openOnSessionStart',
        },

        -- { -- Config to attach to docker container via netcoredbg
        --   type = 'coreclr',
        --   name = 'Attach to Docker Container',
        --   request = 'attach',
        --   justMyCode = false,
        -- },

        -- Godot debug stuff, clogging up menu, commenting out until it works
        -- {
        --   type = 'godot_csharp',
        --   request = 'launch',
        --   name = 'Launch Godot C# Project',
        --   project = function()
        --     -- Ensure uppercase drive letter for Windows
        --     local cwd = vim.fn.getcwd()
        --     return cwd:gsub('^(%l):', string.upper)
        --   end,
        --   launch_scene = true,
        -- },
        --
        -- {
        --   type = 'godot_csharp',
        --   request = 'attach',
        --   name = 'Attach to Godot C# Process',
        --   project = function()
        --     -- Ensure uppercase drive letter for Windows
        --     local cwd = vim.fn.getcwd()
        --     return cwd:gsub('^(%l):', string.upper)
        --   end,
        -- },
      }
      -- Keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/Continue Debug' })
      vim.keymap.set('n', '<C-F5>', dap.terminate, { desc = 'Terminate Debugging Session' })
      vim.keymap.set('n', '<C-F6>', dap.restart, { desc = 'Restart Debugging Session' })
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Step Over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Step Into' })
      vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = 'Step Out' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle Debug UI' })
      vim.keymap.set('n', '<leader>dbca', dap.clear_breakpoints, { desc = 'Clear All Breakpoints' })
      vim.keymap.set('n', '<leader>dr', dap.run_to_cursor, { desc = 'Run to Cursor' })

      -- Conditional breakpoint (stops when condition is true)
      -- x > 10 - stops when x is greater than 10
      -- name == "test" - stops when name equals "test"
      -- items.Count > 0 - stops when collection has items
      -- i % 5 == 0 - stops every 5th iteration
      vim.keymap.set('n', '<leader>dc', function()
        local condition = vim.fn.input 'Breakpoint condition: '
        if condition ~= '' then
          require('dap').set_breakpoint(condition)
        end
      end, { desc = 'Set conditional breakpoint' })

      -- Hit condition breakpoint (stops after N hits)
      -- 5 - stops on the 5th time this line is hit
      -- 10 - stops on the 10th hit
      -- >=3 - stops on 3rd hit and every hit after
      -- %5 - stops every 5 hits (5th, 10th, 15th, etc.)
      --
      -- Hit condition operators:
      --
      -- 5 - exactly on 5th hit
      -- >=5 - on 5th hit and beyond
      -- %5 - every 5th hit
      -- ==5 - only on 5th hit
      vim.keymap.set('n', '<leader>dh', function()
        local hit_condition = vim.fn.input 'Hit condition (e.g. "%5" for every 5th hit): '
        if hit_condition ~= '' then
          require('dap').set_breakpoint(nil, hit_condition)
        end
      end, { desc = 'Set hit condition breakpoint' })

      -- Log point (breakpoint that logs instead of stopping)
      vim.keymap.set('n', '<leader>dl', function()
        local message = vim.fn.input 'Log message: '
        if message ~= '' then
          require('dap').set_breakpoint(nil, nil, message)
        end
      end, { desc = 'Set log point' })

      -- Command to simulate "green button" from VS
      vim.api.nvim_create_user_command('DebugDocker', function()
        print '🔧 Building and launching Docker Compose...'

        -- Step 1: Rebuild and relaunch containers in background
        vim.fn.jobstart('docker-compose -f docker-compose.yml -f docker-compose.override.yml up --build -d', {
          on_stdout = function(_, data)
            if data then
              print(table.concat(data, '\n'))
            end
          end,
          on_stderr = function(_, data)
            if data then
              print(table.concat(data, '\n'))
            end
          end,
          on_exit = function()
            print '🐳 Docker containers started. Waiting for debugger...'
            -- Step 2: Wait briefly, then attach debugger
            vim.defer_fn(function()
              print '🐞 Attaching debugger...'
              dap.continue()
            end, 3000) -- Adjust delay (ms) if needed
          end,
        })
      end, {})

      -- Step 3: Bind key like F5
      vim.keymap.set('n', '<F2>', ':DebugDocker<CR>', { desc = 'Launch Docker + DAP Debugger For BuildBazaar' })
    end,
  },
}
