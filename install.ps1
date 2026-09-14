#requires -Version 5.1
# Setup de herramientas CLI para laptop nueva (Windows 10 Pro).
# Corre las fases en orden porque cada una depende de la anterior
# (git antes de clonar, node antes de npm, PATH refrescado antes de usar lo recien instalado).

$ErrorActionPreference = "Stop"
$ReposDir = "$env:USERPROFILE\Documents\repos"

function Write-Phase($n, $total, $title) {
    Write-Host ""
    Write-Host "[$n/$total] $title" -ForegroundColor Cyan
}

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Install-WingetPackage($id, $source) {
    Write-Host "  winget install $id"
    if ($source) {
        winget install --id $id -e --source $source --silent --accept-package-agreements --accept-source-agreements | Out-Null
    } else {
        winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
    }
}

# --- Preflight -----------------------------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget no esta disponible. Instala 'App Installer' desde la Microsoft Store y vuelve a correr este script." -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Force -Path $ReposDir | Out-Null

# --- Fase 1: paquetes via winget ------------------------------------------
# Nota: python/ffmpeg solo por winget (en la laptop vieja estaban duplicados
# tambien por Chocolatey; aqui se instala una sola vez para no pisarse versiones).
Write-Phase 1 8 "Instalando paquetes con winget"
$wingetPackages = @(
    "Git.Git",
    "GitHub.cli",
    "GoLang.Go",
    "OpenJS.NodeJS",
    "Python.Python.3.14",
    "Microsoft.DotNet.SDK.8",
    "Cloudflare.cloudflared",
    "Microsoft.VisualStudioCode",
    "PostgreSQL.PostgreSQL.16",
    "Gyan.FFmpeg",
    "GnuPG.GnuPG",
    "vim.vim",
    "BurntSushi.ripgrep.MSVC",
    "Microsoft.PowerToys",
    "Microsoft.WindowsTerminal"
)
foreach ($id in $wingetPackages) { Install-WingetPackage $id }
# Notepads App vive en la Microsoft Store, no en el repositorio winget normal.
Install-WingetPackage "9NHL4NSC67WM" "msstore"
Update-SessionPath

# --- Fase 2: extensiones de VS Code ----------------------------------------
Write-Phase 2 8 "Instalando extensiones de VS Code"
$vscodeExtensions = @(
    "anthropic.claude-code",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.debugpy",
    "ms-python.vscode-python-envs",
    "ms-dotnettools.csdevkit",
    "ms-dotnettools.csharp",
    "ms-dotnettools.vscode-dotnet-runtime",
    "ms-vscode.powershell",
    "denoland.vscode-deno",
    "justjavac.vscode-deno-extensionpack",
    "laurencebahiirwa.deno-std-lib-snippets",
    "bmewburn.vscode-intelephense-client",
    "ecmel.vscode-html-css",
    "magnonmatos.crewai-snippets",
    "markdownviewer.enhanced-md-editor",
    "openai.chatgpt"
)
foreach ($ext in $vscodeExtensions) { code --install-extension $ext --force }

# --- Fase 3: PATH de PostgreSQL --------------------------------------------
# En la laptop vieja psql no quedo en el PATH pese a tener Postgres instalado.
# Se agrega aca para no repetir ese vacio.
Write-Phase 3 8 "Agregando PostgreSQL al PATH"
$pgBin = Get-ChildItem "C:\Program Files\PostgreSQL" -Directory -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object { Join-Path $_.FullName "bin" }
if ($pgBin -and (Test-Path $pgBin)) {
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($userPath -notlike "*$pgBin*") {
        [Environment]::SetEnvironmentVariable('Path', "$userPath;$pgBin", 'User')
    }
    Update-SessionPath
    Write-Host "  psql disponible en $pgBin"
} else {
    Write-Host "  No se encontro la carpeta bin de PostgreSQL; revisa manualmente." -ForegroundColor Yellow
}

# --- Fase 4: paquetes npm globales -----------------------------------------
Write-Phase 4 8 "Instalando paquetes npm globales"
npm install -g @angular/cli@22.0.5 deno@2.9.2
corepack enable

# --- Fase 5: paquetes pip ---------------------------------------------------
# torch y openai-whisper arrastran la mayoria de las dependencias transitivas
# que estaban en la laptop vieja (tiktoken, numpy, tqdm, regex, etc).
Write-Phase 5 8 "Instalando paquetes pip (setup de Whisper)"
pip install --upgrade pip
pip install torch openai-whisper pillow pillow_heif numba

# --- Fase 6: clonar terminal-scripts y agregarlo al PATH --------------------
Write-Phase 6 8 "Clonando terminal-scripts"
$scriptsDir = Join-Path $ReposDir "terminal-scripts"
if (-not (Test-Path $scriptsDir)) {
    git clone https://github.com/elparaquecosadeque/terminal-scripts.git $scriptsDir
}
# .env esta en .gitignore en el repo original; se recrea aca con la misma variable.
Set-Content -Path (Join-Path $scriptsDir ".env") -Value "REPOS_DIRECTORY=$ReposDir" -NoNewline
# El propio repo trae su install.ps1, que agrega su carpeta al PATH (User + proceso actual).
& (Join-Path $scriptsDir "install.ps1")
Update-SessionPath

# --- Fase 7: Claude Code + config (plugins, status line, comando /gi) ------
Write-Phase 7 8 "Instalando Claude Code y su configuracion"
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    irm https://claude.ai/install.ps1 | iex
    Update-SessionPath
}
$claudeDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Force -Path "$claudeDir\commands" | Out-Null
$assets = "$PSScriptRoot\claude-config"
if (Test-Path "$claudeDir\settings.json") {
    Copy-Item "$claudeDir\settings.json" "$claudeDir\settings.json.bak" -Force
    Write-Host "  settings.json existente respaldado como settings.json.bak"
}
Copy-Item "$assets\settings.json" "$claudeDir\settings.json" -Force
Copy-Item "$assets\statusline.js" "$claudeDir\statusline.js" -Force
Copy-Item "$assets\commands\gi.md" "$claudeDir\commands\gi.md" -Force

# --- Fase 8: resumen de pasos manuales --------------------------------------
Write-Phase 8 8 "Listo. Pasos manuales pendientes"
Write-Host @"
  1. git config --global user.name / user.email
  2. gh auth login   (autenticar GitHub CLI)
  3. Configurar llaves SSH/GPG si firmas commits
  4. Abrir una sesion nueva de 'claude' para confirmar que los plugins y /gi cargaron
  5. Iniciar sesion en VS Code / extensiones que requieran login (ej. openai.chatgpt)
"@
