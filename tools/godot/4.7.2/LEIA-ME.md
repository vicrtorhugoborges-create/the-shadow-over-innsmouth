# Godot 4.7.2 portátil (não versionado)

Os binários da engine passam do limite de 100 MB por arquivo do GitHub e não estão no repositório. Num computador novo, coloque nesta pasta os quatro arquivos abaixo, obtidos da distribuição oficial do Godot 4.7.2 **Standard** (não a versão .NET) para Windows 64 bits — página de arquivo de versões em godotengine.org/download/archive ou as releases do repositório `godotengine/godot` no GitHub.

| Arquivo | De onde sai |
|---|---|
| `Godot_v4.7.2-stable_win64.exe` | Pacote do editor para Windows 64 bits (zip) |
| `Godot_v4.7.2-stable_win64_console.exe` | Mesmo pacote do editor |
| `windows_debug_x86_64.exe` | Export templates 4.7.2 (arquivo `.tpz`, que é um zip; pasta `templates/`) |
| `windows_release_x86_64.exe` | Mesmos export templates |

O arquivo vazio `_sc_` (versionado) mantém o editor em modo autocontido: as configurações dele ficam em `editor_data/`, dentro desta pasta, sem tocar no perfil do Windows.

## Conferir os arquivos

`SHA256SUMS.txt` tem os hashes da cópia usada para produzir a versão 1.1.0. Depois de copiar os arquivos, no PowerShell, a partir da raiz do projeto:

```powershell
Get-FileHash .\tools\godot\4.7.2\*.exe -Algorithm SHA256
```

Os quatro valores devem coincidir com o manifesto. Se algum diferir, a cópia não é a mesma engine (versão, variante .NET ou arquivo corrompido): não use até resolver, porque o projeto fixa editor e templates da mesma versão (D-001).

Licença: MIT; os textos acompanham o projeto em `docs/licenses/`.
