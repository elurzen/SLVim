local function read_json(path)
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local text = table.concat(data, '\n')
  local ok2, obj = pcall(vim.json.decode, text)
  if not ok2 then
    return nil
  end
  return obj
end

local function find_project_cfg()
  local start = vim.fn.expand '%:p:h'
  local found = vim.fs.find('.nvim/arduino.json', { upward = true, path = start })[1]
  if not found then
    return nil, nil
  end
  return found, read_json(found)
end

local function project_root_from_cfg(cfg_path)
  return vim.fs.dirname(vim.fs.dirname(cfg_path))
end

local function term_run(cmd, cwd)
  vim.cmd 'botright split | resize 14'
  vim.fn.termopen(cmd, { cwd = cwd })
  vim.cmd 'startinsert'
end

local function run_arduino_cli(args_fn)
  local cfg_path, cfg = find_project_cfg()
  if not cfg_path or not cfg then
    vim.notify('No .nvim/arduino.json found in this project.', vim.log.levels.ERROR)
    return
  end

  local root = project_root_from_cfg(cfg_path)

  -- MEGA DEFAULTS (you said Mega only)
  local fqbn = cfg.fqbn or 'arduino:avr:mega'
  local port = cfg.port or 'COM6'
  local sketch = cfg.sketch or 'blink'
  local baud = cfg.baud or 115200

  local cmd = { 'arduino-cli' }
  for _, a in ipairs(args_fn(fqbn, port, sketch, baud)) do
    table.insert(cmd, a)
  end

  term_run(cmd, root)
end

return {
  {
    -- no new plugin required; plenary already in your list but this keeps lazy happy
    'nvim-lua/plenary.nvim',
    lazy = true,
    init = function()
      vim.api.nvim_create_user_command('ArduinoCompile', function()
        run_arduino_cli(function(fqbn, _port, sketch, _baud)
          return { 'compile', '--fqbn', fqbn, sketch }
        end)
      end, {})

      vim.api.nvim_create_user_command('ArduinoUpload', function()
        run_arduino_cli(function(fqbn, port, sketch, _baud)
          return { 'upload', '--fqbn', fqbn, '-p', port, sketch }
        end)
      end, {})

      vim.api.nvim_create_user_command('ArduinoMonitor', function()
        run_arduino_cli(function(_fqbn, port, _sketch, baud)
          -- Most common Windows-friendly syntax:
          return { 'monitor', '--port', port, '--config', ('baudrate=%d'):format(baud) }
        end)
      end, {})

      vim.api.nvim_create_user_command('ArduinoGenFlags', function()
        -- calls tools/gen_compile_flags.ps1 from your project
        run_arduino_cli(function(fqbn, _port, sketch, _baud)
          -- Use PowerShell explicitly for Windows
          return {
            'compile',
            '--fqbn',
            fqbn,
            '--build-path',
            '.nvim/build',
            '--verbose',
            sketch,
          }
        end)
      end, {})

      -- Keymaps
      vim.keymap.set('n', '<leader>ac', '<cmd>ArduinoCompile<CR>', { desc = 'Arduino Compile (Mega)' })
      vim.keymap.set('n', '<leader>au', '<cmd>ArduinoUpload<CR>', { desc = 'Arduino Upload (Mega)' })
      vim.keymap.set('n', '<leader>am', '<cmd>ArduinoMonitor<CR>', { desc = 'Arduino Monitor' })
    end,
  },
}
