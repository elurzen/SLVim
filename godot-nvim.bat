@echo off
set SERVER=\\.\pipe\godot
set FILE=%1
set PROJECT_ROOT=%2
set LINE=%3
set COL=%4

cd /d "%PROJECT_ROOT%"

REM Start Neovim if it's not running
powershell -Command "if (-not (Test-Path '%SERVER%')) { start \"\" \"C:\tools\neovim\nvim-win64\bin\nvim.exe\" --listen %SERVER% & timeout /t 1 >nul }"

REM Open file and move to specific line and column
"C:\tools\neovim\nvim-win64\bin\nvim.exe" --server %SERVER% --remote-send ":e %FILE%<CR>:call cursor(%LINE%, %COL%)<CR>"
