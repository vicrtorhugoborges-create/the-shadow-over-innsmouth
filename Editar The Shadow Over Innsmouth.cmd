@echo off
setlocal
set "editor=%~dp0tools\godot\4.7.2\Godot_v4.7.2-stable_win64.exe"
if not exist "%editor%" (
  echo Godot 4.7.2 portatil nao encontrado em tools\godot\4.7.2.
  pause
  exit /b 1
)
start "" "%editor%" --editor --path "%~dp0game"
