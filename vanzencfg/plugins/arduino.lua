-- vanzencfg/plugins/arduino.lua
-- Arduino CLI integration for Mega 2560 + one reusable bottom terminal window (never more than one split)

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

local function notify_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function has_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'file'
end

-- Read per-project config with Mega defaults
local function get_cfg()
  local cfg_path, cfg = find_project_cfg()
  if not cfg_path or not cfg then
    return nil, nil, 'No .nvim/arduino.json found in this project.'
  end

  local root = project_root_from_cfg(cfg_path)

  local fqbn = cfg.fqbn or 'arduino:avr:mega'
  local port = cfg.port or 'COM3'
  local sketch = cfg.sketch
  local baud = cfg.baud or 115200

  if not sketch or sketch == '' then
    return nil, nil, 'Missing "sketch" in .nvim/arduino.json (expected folder name like "my-buzzer").'
  end

  return root, {
    fqbn = fqbn,
    port = port,
    sketch = sketch,
    baud = baud,
  }, nil
end

-- ============================================================
-- ONE reusable Arduino terminal window (max one split)
-- Robust against window closures / layout changes / tabpages.
-- Creates a fresh terminal buffer per run.
-- NEVER steals focus or puts you into insert mode.
-- ============================================================

local ArduinoTerm = {
  win = nil,
  buf = nil,
  tab = nil,
}

local function win_in_current_tab(win)
  return win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_tabpage(win) == vim.api.nvim_get_current_tabpage()
end

local function ensure_term_win()
  -- Reuse existing Arduino terminal window only if it's in THIS tab
  if win_in_current_tab(ArduinoTerm.win) then
    return ArduinoTerm.win
  end

  -- If buffer exists in some other window in THIS tab, reuse that window
  if ArduinoTerm.buf and vim.api.nvim_buf_is_valid(ArduinoTerm.buf) then
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(w) == ArduinoTerm.buf then
        ArduinoTerm.win = w
        ArduinoTerm.tab = vim.api.nvim_get_current_tabpage()
        return w
      end
    end
  end

  -- Otherwise create bottom split in the current tab (but do not keep focus)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd 'botright 14split'
  local win = vim.api.nvim_get_current_win()

  ArduinoTerm.win = win
  ArduinoTerm.tab = vim.api.nvim_get_current_tabpage()

  -- Return focus
  if vim.api.nvim_win_is_valid(prev) then
    vim.api.nvim_set_current_win(prev)
  end

  return win
end

local function wipe_buf(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
end

-- focus_terminal: if true, jump to terminal and enter insert
-- if false, run in terminal but keep user exactly where they were
local function term_run(cmd, cwd, focus_terminal)
  local prev_win = vim.api.nvim_get_current_win()
  local prev_mode = vim.api.nvim_get_mode().mode

  local win = ensure_term_win()

  -- If the stored window is valid but not in this tab, create a new one in this tab
  if not win_in_current_tab(win) then
    ArduinoTerm.win = nil
    win = ensure_term_win()
  end

  if not win_in_current_tab(win) then
    notify_err 'Could not create/reuse Arduino terminal window.'
    return
  end

  -- Fresh terminal buffer each run
  wipe_buf(ArduinoTerm.buf)
  local buf = vim.api.nvim_create_buf(false, true)
  ArduinoTerm.buf = buf

  -- Set buffer into the window (retry once if the window dies mid-flight)
  local ok = pcall(vim.api.nvim_win_set_buf, win, buf)
  if not ok then
    ArduinoTerm.win = nil
    win = ensure_term_win()
    if not win_in_current_tab(win) then
      notify_err 'Arduino terminal window became invalid.'
      return
    end
    pcall(vim.api.nvim_win_set_buf, win, buf)
  end

  -- Run terminal job in that window, but don't force insert unless asked
  vim.api.nvim_win_call(win, function()
    pcall(vim.api.nvim_buf_set_name, buf, 'Arduino://terminal')
    vim.fn.termopen(cmd, { cwd = cwd })
    if focus_terminal then
      vim.cmd 'startinsert'
    end
  end)

  if focus_terminal then
    -- If caller wants focus, go there (and insert already started)
    vim.api.nvim_set_current_win(win)
    return
  end

  -- Otherwise: restore exact focus + mode
  if prev_win and vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end

  -- Ensure we don't end up in insert mode after mapping
  if prev_mode:sub(1, 1) == 'n' then
    vim.cmd 'stopinsert'
  end
end

-- ============================================================
-- Arduino runners
-- ============================================================

local function run_arduino_cli(args_fn, focus_terminal)
  local root, cfg, err = get_cfg()
  if err then
    notify_err(err)
    return
  end

  local cmd = { 'arduino-cli' }
  vim.list_extend(cmd, args_fn(cfg))

  term_run(cmd, root, focus_terminal)
end

local function run_pwsh_script(script_rel, args_fn, focus_terminal)
  local root, cfg, err = get_cfg()
  if err then
    notify_err(err)
    return
  end

  local script_path = root .. '\\' .. script_rel:gsub('/', '\\')
  if not has_file(script_path) then
    notify_err('Missing script: ' .. script_path)
    return
  end

  local cmd = { 'powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script_path }
  vim.list_extend(cmd, args_fn(cfg))

  term_run(cmd, root, focus_terminal)
end

local function lsp_restart_clangd()
  local ok = pcall(vim.cmd, 'LspRestart clangd')
  if ok then
    return
  end

  for _, client in ipairs(vim.lsp.get_clients { name = 'clangd' }) do
    client.stop()
  end
  vim.defer_fn(function()
    pcall(vim.cmd, 'LspStart clangd')
  end, 200)
end

-- ============================================================
-- Plugin spec
-- ============================================================

return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
    init = function()
      -- NOTE: All leader commands run WITHOUT stealing focus or entering insert mode.
      vim.api.nvim_create_user_command('ArduinoGenFlags', function()
        run_pwsh_script('tools/gen_compile_flags.ps1', function(cfg)
          return { '-SketchPath', ('.\\' .. cfg.sketch), '-FQBN', cfg.fqbn }
        end, false)
        vim.defer_fn(lsp_restart_clangd, 300)
      end, {})

      vim.api.nvim_create_user_command('ArduinoCompile', function()
        vim.cmd 'ArduinoGenFlags'
        run_arduino_cli(function(cfg)
          return { 'compile', '--fqbn', cfg.fqbn, cfg.sketch }
        end, false)
      end, {})

      vim.api.nvim_create_user_command('ArduinoUpload', function()
        vim.cmd 'ArduinoGenFlags'
        run_arduino_cli(function(cfg)
          return { 'upload', '--fqbn', cfg.fqbn, '-p', cfg.port, cfg.sketch }
        end, false)
      end, {})

      vim.api.nvim_create_user_command('ArduinoMonitor', function()
        -- Monitor is the one you usually WANT focus for; keep it false if you prefer.
        run_arduino_cli(function(cfg)
          return { 'monitor', '--port', cfg.port, '--config', ('baudrate=%d'):format(cfg.baud) }
        end, false)
      end, {})

      vim.api.nvim_create_user_command('ArduinoTerm', function()
        local win = ensure_term_win()
        if win_in_current_tab(win) then
          vim.api.nvim_set_current_win(win)
          vim.cmd 'startinsert'
        else
          notify_err 'Arduino terminal window is not available.'
        end
      end, {})

      -- Keymaps
      vim.keymap.set('n', '<leader>ag', '<cmd>ArduinoGenFlags<CR>', { desc = 'Arduino Gen compile_flags.txt' })
      vim.keymap.set('n', '<leader>ac', '<cmd>ArduinoCompile<CR>', { desc = 'Arduino Compile (Mega)' })
      vim.keymap.set('n', '<leader>au', '<cmd>ArduinoUpload<CR>', { desc = 'Arduino Upload (Mega)' })
      vim.keymap.set('n', '<leader>am', '<cmd>ArduinoMonitor<CR>', { desc = 'Arduino Monitor' })
      vim.keymap.set('n', '<leader>at', '<cmd>ArduinoTerm<CR>', { desc = 'Arduino Terminal (focus)' })
    end,
  },
}
