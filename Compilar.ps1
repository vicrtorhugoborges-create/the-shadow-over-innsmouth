$ErrorActionPreference = 'Stop'
# Exporta a build Windows com o Godot 4.7.2 portátil deste projeto (D-001, Q-004).
$projectRoot = $PSScriptRoot
$enginePath = Join-Path $projectRoot 'tools\godot\4.7.2\Godot_v4.7.2-stable_win64_console.exe'
$projectPath = Join-Path $projectRoot 'game'
$buildFolder = Join-Path $projectRoot 'builds\The Shadow Over Innsmouth'
$buildPath = Join-Path $buildFolder 'The Shadow Over Innsmouth.exe'
if (-not (Test-Path -LiteralPath $enginePath)) { throw 'Godot 4.7.2 portatil ausente em tools\godot\4.7.2.' }
New-Item -ItemType Directory -Force -Path $buildFolder | Out-Null
& $enginePath --headless --path $projectPath --export-release 'Windows Desktop' $buildPath --log-file (Join-Path $projectRoot 'docs\qa\export.log')
if ($LASTEXITCODE -ne 0) { throw 'Falha ao exportar. Consulte docs/qa/export.log.' }
Copy-Item -LiteralPath (Join-Path $projectRoot 'docs\licenses\GODOT_COPYRIGHT.txt') -Destination $buildFolder -Force
Copy-Item -LiteralPath (Join-Path $projectRoot 'docs\licenses\GODOT_LICENSE.txt') -Destination $buildFolder -Force
Copy-Item -LiteralPath (Join-Path $projectRoot 'docs\distribuicao\LEIA-ME.txt') -Destination $buildFolder -Force
Write-Output ('Build pronta: ' + $buildPath)
