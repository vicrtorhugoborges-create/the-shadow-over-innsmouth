@echo off
setlocal
set "gameexe=%~dp0builds\The Shadow Over Innsmouth\The Shadow Over Innsmouth.exe"
if not exist "%gameexe%" (
  echo Executavel nao encontrado. Rode Compilar.ps1 ou consulte o README desta pasta.
  pause
  exit /b 1
)
start "" "%gameexe%"
