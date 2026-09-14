# Inventario de herramientas CLI — laptop actual (Windows 10 Pro)
Generado: 2026-09-12

## Gestores de paquetes
| Tool | Estado |
|---|---|
| winget | Instalado (App Installer 1.29.290.0) |
| Chocolatey | v2.3.0 |
| Scoop | No instalado |

## Runtimes / lenguajes
| Tool | Versión | Fuente |
|---|---|---|
| Node.js | 24.17.0 | winget |
| npm | 11.13.0 | (viene con Node) |
| Go | 1.26.4 | winget |
| Python | 3.14.6 (default) | winget + choco (duplicado) |
| Python | 3.12.4 (segunda versión, sigue instalada) | winget + choco |
| .NET SDK | 8.0.303 | Visual Studio installer |
| Deno | 2.9.2 | npm global |

⚠️ Python y ffmpeg están instalados por **dos gestores a la vez** (winget y choco). En la laptop nueva, elige uno solo para evitar versiones pisándose.

## CLI tools de desarrollo (en PATH, verificados con `--version`)
| Tool | Versión |
|---|---|
| git | 2.45.2.windows.1 |
| gh (GitHub CLI) | 2.97.0 |
| ripgrep (rg) | 14.1.1 |
| gpg | 2.4.5 |
| vim | 9.1 |
| curl | 8.8.0 |
| tar | GNU tar 1.35 |
| unzip | presente |
| ffmpeg | 7.0.1 (build en PATH; choco tiene 8.1.2 registrado, revisar cuál gana) |
| cloudflared | 2026.8.3 |
| code (VS Code CLI) | 1.136.2 |
| claude (Claude Code) | 2.1.269 |

## npm — paquetes globales reales
- `@angular/cli@22.0.5`
- `corepack@0.35.0`
- `deno@2.9.2`

(Lo demás que aparece en `npm ls -g` — `@angular/core`, `@gblp/bass-notes`, `@gblp/chord-finder`, `@gblp/circle-of-fifths`, `@gblp/music-theory` — son **symlinks a proyectos locales tuyos** en `Documents\repos\`, no paquetes globales reales. No hace falta instalarlos en la laptop nueva vía npm; se generan al clonar esos repos y correr su build.)

## Python — pip global (perfil: transcripción/ML con Whisper)
`torch`, `openai-whisper`, `tiktoken`, `numpy`, `numba`, `llvmlite`, `sympy`, `networkx`, `pillow`, `pillow_heif`, `requests`, `PyYAML`, `tqdm`, y dependencias transitivas (`certifi`, `charset-normalizer`, `filelock`, `fsspec`, `idna`, `MarkupSafe`, `Jinja2`, `mpmath`, `more-itertools`, `regex`, `setuptools`, `typing_extensions`, `urllib3`, `colorama`).

→ Esto es claramente un setup para transcribir audio con Whisper. En la laptop nueva: `pip install openai-whisper torch` alcanza para traer casi todo (torch arrastra la mayoría de las demás).

## Utilidades de sistema (detectadas tras revisión adicional)
| Tool | Versión | Fuente |
|---|---|---|
| PowerToys (Preview) x64 | 0.87.1 | winget (`Microsoft.PowerToys`) |
| Windows Terminal | 1.24.11911.0 | winget (`Microsoft.WindowsTerminal`) |
| Notepads App | 1.5.6.0 | Microsoft Store (`9NHL4NSC67WM`) |
| oh-my-posh | 29.14.0 | winget (`JanDeDobbeleer.OhMyPosh`) — tema por defecto, sin `--config` custom en el perfil |
| Fuente Nerd Font | MesloLGLDZ (y variantes Meslo/Monoid) | `oh-my-posh font install meslo` |

`$PROFILE` (`Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`) tiene una sola línea: `oh-my-posh init pwsh | Invoke-Expression`. Windows Terminal usa `MesloLGLDZ Nerd Font Propo` como fuente del perfil "Windows PowerShell" (el que es default).

## VS Code — extensiones instaladas
`anthropic.claude-code`, `ms-python.python`, `ms-python.vscode-pylance`, `ms-python.debugpy`, `ms-python.vscode-python-envs`, `ms-dotnettools.csdevkit`, `ms-dotnettools.csharp`, `ms-dotnettools.vscode-dotnet-runtime`, `ms-vscode.powershell`, `denoland.vscode-deno`, `justjavac.vscode-deno-extensionpack`, `laurencebahiirwa.deno-std-lib-snippets`, `bmewburn.vscode-intelephense-client`, `ecmel.vscode-html-css`, `magnonmatos.crewai-snippets`, `markdownviewer.enhanced-md-editor`, `openai.chatgpt`.

## Bases de datos
| Tool | Versión |
|---|---|
| PostgreSQL | 16 (server + client instalados vía winget) |
| SQL Server LocalDB | 15.0.4153.1 |
| SQL Server Management Studio | 20.2 |
| DBeaver Community | 24.1.3 |

⚠️ `psql` no está en el PATH pese a que Postgres 16 está instalado — revisar si fue deliberado o un pendiente en esta laptop.

## Chocolatey — paquetes locales completos
`ffmpeg`, `python`/`python3`/`python312`/`python314`, `vcredist140`, `vcredist2015`, `visualstudio2019buildtools` + `vctools`, `visualstudio2026buildtools` + `vctools`, `visualstudio-installer`, más extensiones internas de Chocolatey (`*.extension`) y parches KB de Windows — estos últimos no aplican a una laptop nueva, son hotfixes de este equipo.

## Claude Code — configuración a portar
- Versión: 2.1.269
- Plugins instalados (`~/.claude/settings.json`): `ponytail@ponytail`, `mattpocock-skills@mattpocock`, `impeccable@impeccable`, `i-have-adhd@i-have-adhd` (todos habilitados); `frontend-design@claude-plugins-official` deshabilitado.
- Marketplaces agregados: DietrichGebert/ponytail, mattpocock/skills, pbakaus/impeccable, ayghri/i-have-adhd.
- Comando personalizado: `~/.claude/commands/gi.md` (encadena grilling + impeccable).
- Status line: `~/.claude/statusline.js` (muestra cwd + rama git), referenciado desde `settings.json`.

## No detectado (buscado explícitamente, ausente en esta laptop)
Docker, kubectl, terraform, aws-cli, az (Azure CLI), gcloud, jq, fd, fzf, bat, exa, lazygit, tmux, cargo/rustc, java/mvn/gradle, mysql cliente, redis-cli, 7z standalone, ansible, packer, vagrant, helm, minikube, k9s, wrangler, vercel/netlify/supabase/firebase CLIs, scoop, starship, oh-my-posh, direnv, asdf, nvm, pyenv.

## WSL
Comando `wsl` existe pero `wsl -l -v` no devolvió una lista de distros (salió el texto de ayuda) — probablemente **no hay ninguna distro Linux instalada** en esta laptop. Confirmar manualmente si esto importa para el nuevo equipo.

## Fuera de alcance de este inventario (no son "CLI tools")
GUI-only: Google Chrome, Microsoft Edge, VS Code (la app en sí, aparte de su CLI), DaVinci Resolve, Audacity, CapCut, Kaspersky, OneDrive, Office, juegos de Steam, apps de Microsoft Store — el `winget list` completo (222 líneas) tiene mucho de esto; se filtró para quedarnos solo con lo relevante a una terminal de desarrollo.
