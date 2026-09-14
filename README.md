# cli-tools-setup

Replica en una laptop nueva (Windows 10 Pro) las herramientas CLI de este equipo.

## Uso

```powershell
cd cli-tools-setup
.\install.ps1
```

Correr desde una consola normal (no hace falta admin salvo que winget lo pida para algun paquete puntual). Tarda ~15-25 min según tu internet (torch es el paquete más pesado).

## Qué hace, en orden

1. Instala 16 paquetes con winget (git, gh, go, node, python 3.14, .NET SDK 8, cloudflared, VS Code, PostgreSQL 16, ffmpeg, gpg, vim, ripgrep, PowerToys, Windows Terminal, oh-my-posh) + Notepads App (Microsoft Store).
2. Instala las 17 extensiones de VS Code que usás (requiere que `code` ya esté en el PATH desde el paso anterior).
3. Configura oh-my-posh: instala la fuente Nerd Font Meslo, agrega `oh-my-posh init pwsh | Invoke-Expression` a tu `$PROFILE` (tema por defecto, no usás uno custom), y aplica esa fuente al perfil "Windows PowerShell" de Windows Terminal.
4. Agrega el bin de PostgreSQL al PATH (en la laptop vieja faltaba: `psql` no era accesible).
5. Instala paquetes npm globales: `@angular/cli`, `deno`, + `corepack enable`.
6. Instala paquetes pip: `torch`, `openai-whisper`, `pillow`, `pillow_heif`, `numba` (setup de transcripción con Whisper).
7. Clona `terminal-scripts`, recrea su `.env` (`REPOS_DIRECTORY`) y corre su propio `install.ps1` para sumarlo al PATH.
8. Instala Claude Code (si no está) y copia `claude-config/` a `~/.claude/` (settings con los 4 plugins + status line + comando `/gi`).
9. Imprime los pasos manuales que no se pueden automatizar (login de `gh`, git user/email, llaves SSH/GPG).

## Antes de correrlo

Si tu política de ejecución de PowerShell bloquea el script (`PSSecurityException`):

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Decisiones ya tomadas (no preguntadas de nuevo)

- **Python y ffmpeg: solo winget.** La laptop vieja los tenía duplicados también por Chocolatey — acá se instalan una sola vez para que no compitan dos versiones en el PATH. Chocolatey no se instala en absoluto (lo único real que traía, aparte de esos duplicados, eran redistribuibles de Visual Studio fuera del alcance de "herramientas CLI").
- **Python 3.12 (legado) no se replica** — solo 3.14, la versión activa.
- **VS Code Build Tools / Visual Studio 2019-2026** no se instalan — pertenecen a un setup de IDE completo, no a herramientas de terminal.

## Qué NO clona este script

Solo `terminal-scripts` (lo que pediste). Los demás repos personales (`bass-guitar`, `chord-generator`, etc.) no se clonan automáticamente — pídemelo aparte si quieres sumarlos.

## Archivos

- `cli-tools-inventory.md` — inventario completo de la laptop origen, con lo detectado y lo explícitamente ausente.
- `install.ps1` — el script.
- `claude-config/` — copia de `settings.json`, `statusline.js` y `commands/gi.md` tal como están en esta laptop.
