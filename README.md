# 💤 LazyVim Config — JDL

Configuración personal de [LazyVim](https://github.com/LazyVim/LazyVim) para Neovim, con:

- Tema **Catppuccin (mocha)**
- **Treesitter** para parseo de sintaxis (`typescript`, `javascript`, `docker`, `php`, `markdown`, `yaml`)
- **Blink.cmp** para autocompletado basado en LSP
- **Mason** para gestión de LSPs:
  - `typescript-language-server` (TypeScript/JavaScript)
  - `docker-language-server` (Docker)
  - `intelephense` (PHP)
  - `yamlls` (YAML)
  - `lua_ls` (Lua / la propia config de Neovim)
- **Snacks.nvim** (picker/explorer/terminal)
- Integración con **Lazygit**

> ⚠️ **Guía para usuarios de Linux (Debian/Ubuntu).** Si tu distro es otra (Arch, Fedora), adapta los `apt install` al gestor de paquetes equivalente.

---

## 📋 Visión general de requisitos

| Dependencia | ¿Por qué? | ¿Cómo se instala? |
|---|---|---|
| Neovim ≥ 0.10 | núcleo de LazyVim | manual (tarball oficial) |
| git | clonar plugins y lazy.nvim | apt |
| curl / wget | descargar herramientas | apt |
| gcc / make (`build-essential`) | compilar parsers de treesitter | apt |
| unzip | extraer paquetes de Mason | apt |
| ripgrep (`rg`) | búsqueda en LazyVim | apt |
| fd | explorador/picker rápido | apt (`fd-find`) |
| Node.js ≥ 18 | LSPs basados en npm (tsserver, intelephense, yamlls) | apt o nvm |
| python3 | herramientas de Mason y LSPs Py | apt (generalmente ya incluida) |
| Nerd Font | iconos de la UI | manual |
| lazygit | panel git `<leader>gg` | PPA oficial |
| GitHub CLI (`gh`) | credential helper de git | repo oficial apt |

---

## 🚀 Instalación paso a paso

### 1. Dependencias base

```bash
sudo apt update
sudo apt install -y git curl wget build-essential unzip ripgrep fd-find python3 nodejs npm
```

**Nota `fd`:** en Debian/Ubuntu el binario se instala como `fdfind`, pero LazyVim lo busca como `fd`. Crea un enlace simbólico:

```bash
mkdir -p ~/.local/bin
ln -s "$(command -v fdfind)" ~/.local/bin/fd
```

Verifica que tu `PATH` incluya `~/.local/bin` (agrega esto a `~/.bashrc` si falta):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Neovim ≥ 0.10

La versión de `apt` en Ubuntu 24.04 (0.9.5) es **demasiado vieja** para LazyVim. Instala la última estable desde el tarball oficial:

```bash
# Descarga la última versión
curl -fLo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Instala en /opt
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf /tmp/nvim.tar.gz
```

Agrega Neovim a tu `PATH` (`~/.bashrc`):

```bash
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
source ~/.bashrc
```

Verifica:

```bash
nvim --version   # debe mostrar v0.10 o superior
```

> ¿Ya tienes Neovim instalado con snap? Puede interferir: `sudo snap remove nvim` y repite el paso.

### 3. Nerd Font (iconos)

LazyVim necesita una fuente con iconos. Descarga e instala **JetBrainsMono Nerd Font**:

```bash
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/jetbrains.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o /tmp/jetbrains.zip -d ~/.local/share/fonts
fc-cache -fv
```

Luego configura tu terminal para usar **"JetBrainsMono Nerd Font"** (o cualquier otra Nerd Font, p. ej. `UbuntuMonoNerdFontMono`). Sin esto verás rectángulos `?` en lugar de iconos.

### 4. Lazygit

Agrega el PPA oficial e instala:

```bash
sudo add-apt-repository -y ppa:lazygit-team/release
sudo apt update
sudo apt install -y lazygit
```

Verifica:

```bash
lazygit --version
```

Crea la carpeta de configuración (el archivo `config.yml` puede quedarse vacío al inicio, LazyVim usa sus valores por defecto):

```bash
mkdir -p ~/.config/lazygit
touch ~/.config/lazygit/config.yml
```

Consulta el [ejemplo de configuración](#-configuracion-de-lazygit) más abajo.

### 5. GitHub CLI (`gh`)

Tu `.gitconfig` usa `gh` como credencial para GitHub, así que hay que instalarlo y autenticarse:

```bash
# Agrega el repositorio oficial de GitHub
sudo mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/keyring/githubcli-archive-keyring.gpg \
  && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install -y gh
```

Inicia sesión (sigue las instrucciones interactivas):

```bash
gh auth login
```

### 6. Configuración global de git

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global init.defaultBranch main
```

Y habilita `gh` como credential helper (como en mi config):

```bash
git config --global credential.https://github.com.helper "!/usr/bin/gh auth git-credential"
```

### 7. Instalar esta configuración

> ⚠️ **Respaldos:** se moverán (no se borran) tus configuraciones actuales.

```bash
# Backup de tu config actual (opcional pero recomendado)
mv ~/.config/nvim{,.bak} 2>/dev/null || true
mv ~/.local/share/nvim{,.bak} 2>/dev/null || true
mv ~/.local/state/nvim{,.bak} 2>/dev/null || true
mv ~/.cache/nvim{,.bak} 2>/dev/null || true

# Clona el repo en la ubicación esperada por Neovim
git clone https://github.com/DevDeLeonJS/lazyvim-jdl.git ~/.config/nvim
```

### 8. Primer arranque

```bash
nvim
```

En la primera ejecución:

1. **lazy.nvim** se autoinstala y descarga **todos los plugins** (~1-2 min).
2. **Mason** instala automáticamente los LSPs de tu config (tsserver, docker, intelephense, yamlls, lua_ls).
3. **Treesitter** descarga y **compila** los parsers (necesitas `gcc` del paso 1).

Puede tardar unos minutos; algunas barras se ven "congeladas" mientras compila. Termina y cierra con `:qa`, luego abre `nvim` de nuevo.

### 9. Verificación

```bash
nvim
```

Dentro de Neovim ejecuta:

```
:LazyHealth        → todos los plugins en `OK`
:Mason             → LSPs instalados con ✓
:TSInstallInfo     → parsers de syntax instalados
```

---

## ⚙️ LSPs y autocompletado

Los LSPs instalados automáticamente por Mason dan autocompletado y diagnóstico (via **Blink.cmp**):

| Lenguaje | Servidor LSP | Estado |
|---|---|---|
| TypeScript / JavaScript | `typescript-language-server` | ✅ auto |
| Docker (`dockerfile`, `compose`) | `docker-language-server` | ✅ auto |
| PHP | `intelephense` | ✅ auto |
| YAML | `yamlls` | ✅ auto |
| Lua (config de Neovim) | `lua_ls` | ✅ auto |

> **Requisito:** los LSPs basados en npm (tsserver, intelephense, yamlls) necesitan **Node.js ≥ 18**, y `intelephense` además acepta la licencia en la primera carga.

### Instalar LSPs adicionales

Desde Neovim:

```
:MasonInstall <servidor>        # p. ej. :MasonInstall pyright
```

- Python → `pyright` / `basedpyright` (requiere `python3`)
- Bash → `bashls`
- JSON → `jsonls`
- Go → `gopls`
- C/C++ → `clangd`
- Markdown → `markdownlint` / `marksman`

O agrégalos a `lua/plugins/my-config.lua` en `mason.ensure_installed` para instalarlos siempre.

---

## 🔧 Configuración de Lazygit

`~/.config/lazygit/config.yml`. El tuyo puede quedar vacío, pero un ejemplo mínimo con tema oscuro:

```yaml
gui:
  theme:
    lightTheme: false
    activeBorderColor:
      - green
      - bold
    selectedLineBgColor:
      - reverse
git:
  paging:
    colorArg: always
```

LazyVim abre Lazygit con `<leader>gg` (espacio + gg).

---

## 🗺️ Atajos principales

| Atajo | Acción |
|---|---|
| `<Space>` | leader key |
| `<leader>gg` | abrir Lazygit |
| `<leader>ff` | buscar archivos |
| `<leader>fg` | buscar texto (grep) |
| `<C-c>` (visual) | copiar al portapapeles |
| `<C-v>` | pegar del portapapeles |
| `<leader>e` | explorador de archivos (Snacks) |

---

## 🚑 Solución de problemas

| Problema | Causa | Fix |
|---|---|---|
| Iconos `?` o cuadros | falta Nerd Font | paso 3, y cambia la fuente de tu terminal |
| `fd: command not found` | sin enlace simbólico | paso 1 |
| Plugins fallan con las teclas de portapapeles | falta unclipboard | instala `xclip`/`wl-clipboard` |
| Treesitter no compila | falta `gcc` | `sudo apt install build-essential` |
| LSP no inicia (`tsserver`/`intelephense`) | Node.js en versión de snap/apt vieja | `sudo apt install nodejs npm` o instala vía nvm |
| LSP pendiente al abrir PHP | licencia intelephense | acepta el diálogo o instala en `:Mason` |
| `nvim: command not found` | PATH mal configurado | revisa paso 2 (`/opt/nvim-linux-x86_64/bin`) |
| Plugins rotos tras un update | versión de Neovim vieja | actualiza a ≥ 0.10 |