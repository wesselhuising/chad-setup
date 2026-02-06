# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**chad-setup** is a dotfiles and developer environment configuration repository that manages a complete terminal and code editor setup for macOS and Linux. It provides an integrated development environment centered around Neovim, with tools for Python development, data science workflows (Jupyter notebooks), infrastructure-as-code (Terraform), and AI-assisted development.

## Installation & Setup Commands

### macOS Installation
```bash
make install-osx
```
Installs Homebrew packages (tmux, neovim, lazygit, python@3.11, fonts, etc.), sets up symlinks, and configures environment variables.

### Linux Installation
```bash
make install-linux
```
Uses apt package manager, compiles Alacritty from source (Rust), installs Neovim v0.11.0, and sets up all configurations.

### Individual Component Installation
```bash
make install-nvim      # Install Neovim config and Python LSP dependencies
make install-tmux      # Install Tmux config and plugins
make install-fzf       # Install fzf fuzzy finder
make install-cargo     # Install Rust/Cargo
```

### Pull Configuration Back to Repository
```bash
make pull
```
Syncs changes from `~/.tmux.conf` and `~/.config/nvim/` back to the repository.

## Architecture & Structure

### Core Technology Stack
- **Editor**: Neovim 0.11+ with LazyVim framework
- **Plugin Manager**: lazy.nvim (67 plugins tracked in `nvim/lazy-lock.json`)
- **Terminal Multiplexer**: Tmux 3.2+ with auto-recovery (resurrect/continuum plugins)
- **Terminal Emulator**: Alacritty (GPU-accelerated)
- **Shell**: Bash 5+

### Directory Layout
```
chad-setup/
├── nvim/                      # Neovim configuration (primary development tool)
│   ├── init.lua               # Entry point
│   ├── lua/config/
│   │   ├── lazy.lua           # Plugin loader, Mason LSP setup, Quarto/Molten initialization
│   │   ├── keymaps.lua        # Custom keybindings (Molten, LazyDocker, Claude Code)
│   │   ├── options.lua        # Vim options (mostly LazyVim defaults)
│   │   └── autocmds.lua       # Auto-commands
│   ├── lua/plugins/           # Individual plugin configurations
│   │   ├── avante.lua         # AI assistant (OpenAI GPT-5, Gemini 2.5-flash)
│   │   ├── claudecode.lua     # Claude Code integration
│   │   ├── molten.lua         # Jupyter notebook execution engine
│   │   ├── quarto.lua         # Scientific document/notebook support
│   │   ├── nvim-lspconfig.lua # LSP server configuration
│   │   └── [other plugins]    # Lazygit, FZF, Terraform, etc.
│   ├── lazy-lock.json         # Plugin version lock file
│   └── stylua.toml            # Lua formatter configuration
├── bash/                      # Shell configuration
│   ├── .bashrc                # Main shell config (Python 3.11 PATH, XDG_CONFIG_HOME)
│   └── .bash_profile          # Login shell config (Homebrew environment)
├── tmux/                      # Terminal multiplexer
│   └── .tmux.conf             # Tmux config (Dracula theme, Vi keybindings, plugins)
├── alacritty/                 # Terminal emulator
│   └── alacritty.toml         # Alacritty config (FiraCode Nerd Font, Dracula, 0.8 opacity)
├── Makefile                   # Installation orchestration
├── lazygit_config.yml         # LazyGit configuration
└── README.md                  # Minimal setup instructions
```

### Configuration Entry Points

**Neovim Startup Flow**:
1. `nvim/init.lua` executes
2. Loads `lua/config/lazy.lua` which:
   - Bootstraps lazy.nvim plugin manager
   - Configures LazyVim with TypeScript, JSON, mini-animate extras
   - Sets up Mason (tool installer) with pylsp, ruff, tflint
   - Initializes Python LSP with Black, isort, Ruff, Jedi
   - Sets up Quarto with molten as code runner
   - Imports all plugin configs from `lua/plugins/`
3. Keymaps from `keymaps.lua` register on VeryLazy event
4. Individual plugins lazy-load on demand

**Symlink Locations** (configurations are symlinked to standard locations):
- `~/.config/nvim/` ← `nvim/`
- `~/.tmux.conf` ← `tmux/.tmux.conf`
- `~/.config/alacritty/` ← `alacritty/`
- `~/.config/lazygit/config.yml` ← `lazygit_config.yml`
- `~/.bashrc` ← `bash/.bashrc`
- `~/.bash_profile` ← `bash/.bash_profile`

## Development Workflows & Keymaps

### Code Execution & Notebooks (Molten + Quarto)
Keymaps use `<localleader>` (default: `\`) and require code cells marked with `<!-- #region -->` or ` ```{language} ` in markdown files.

| Keymap | Action |
|--------|--------|
| `<localleader>rc` | Run current cell |
| `<localleader>ra` | Run current cell and above |
| `<localleader>rA` | Run all cells |
| `<localleader>rl` | Run current line |
| `<localleader>r` (visual) | Run selected range |
| `<localleader>e` | Evaluate operator |
| `<localleader>rr` | Re-evaluate cell |
| `<localleader>os` | Open output window |
| `<localleader>oh` | Close output window |
| `<localleader>mx` | Open HTML output in browser |
| `<localleader>md` | Delete Molten cell |

### AI & Productivity Tools
| Keymap | Tool | Action |
|--------|------|--------|
| `<leader>cc` | Claude Code | Toggle Claude Code integration (floating window) |
| `<leader>k` | LazyDocker | Toggle Docker UI |
| (in lazygit) | Avante | Use `a` in LazyGit to generate AI commit messages (via Bunnai) |

### Standard LazyVim Keymaps
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep search
- `<leader>fb` - Find buffers
- `<leader>ld` - Lazy plugin manager
- `<leader>w` - Delete current buffer (custom)

### LSP Keymaps (provided by LazyVim)
- `gd` - Go to definition
- `gr` - References
- `<leader>rn` - Rename
- `K` - Hover info
- `<leader>ca` - Code actions
- `<leader>gf` - Format

## Language Support & LSP Configuration

### Python Development (Primary)
- **LSP**: python-lsp-server (pylsp)
- **Installed Plugins**:
  - Black (code formatter)
  - isort (import sorter)
  - Ruff (linter)
  - Jedi (completion with fuzzy matching)
- **Linter**: Ruff (via Mason)
- **Version**: Python 3.11 (pinned in bash/.bashrc)

### Infrastructure-as-Code
- **Terraform**: tflint-nvim (linting)
- Configured via `lua/plugins/tflint.lua`

### Data Science & Notebooks
- **Quarto**: Scientific document support with R, Python, Rust
- **Molten**: Jupyter-like execution engine for inline code
- **Jupytext**: Notebook format conversion (markdown ↔ .ipynb)
- **Venv Selector**: Virtual environment selection for notebooks

### Other Language Support (via LazyVim)
- TypeScript/JavaScript (extras.lang.typescript)
- JSON (extras.lang.json)
- Markdown (syntax + treesitter)
- SQL (via DABod extension)
- Docker, Rust, CMake, YAML, TOML support included

## Key Configuration Details

### Python LSP Setup (`lua/config/lazy.lua:67-97`)
Configured with specific plugin enablements:
- `black.enabled = true` (formatting)
- `isort.enabled = true` (import sorting)
- `ruff.enabled = true` (linting)
- `jedi_completion.fuzzy = true` (fuzzy code completion)
- `pylint.enabled = false` (disabled due to import errors)
- `pyflakes.enabled = false` (redundant with Ruff)
- `pycodestyle.enabled = false` (redundant with Ruff)

### Notebook Configuration (`lua/config/lazy.lua:102-128`)
Quarto is initialized with:
- Languages: Python, R, Rust
- Diagnostics enabled (triggered on BufWritePost)
- Code runner: molten
- Custom keymaps for cell execution

### AI Assistants & Tools
- **Avante**: OpenAI GPT-5 (primary), Gemini 2.5-flash fallback
- **Claude Code**: Configured in `lua/plugins/claudecode.lua` with:
  - Floating window (80% width/height, centered)
  - Auto-refresh on file changes
  - Git root as working directory
- **GitHub Copilot**: copilot.lua plugin (legacy support in `nvim/pack/`)

### Terminal Customization
- **Font**: FiraCode Nerd Font 17pt (supports Nerd font icons)
- **Colorscheme**: Dracula (consistent across nvim, tmux, alacritty)
- **Shell**: Bash 5+ with custom key repeat tuning (macOS)
- **Tmux Prefix**: Ctrl-S
- **Tmux Vi Mode**: hjkl navigation enabled
- **Tmux Status**: Top position with CPU, RAM, weather, SSH session
- **Tmux Sessions**: Auto-restore via resurrect/continuum plugins

## Git Workflow Integration

**LazyGit Integration**:
- Opens via `:LazyGit` in Neovim or `lazygit` from shell
- Configured in `lazygit_config.yml` with:
  - Custom AI commit message generation via "bunx bunnai" command
  - Dracula theme (matches editor)

**Claude Code Integration**:
- Opens via `<leader>cc` in Neovim
- Works with git-aware working directory
- Floating window UI for seamless integration

## Development Notes & Patterns

### Plugin Management
- **lazy.nvim**: Declarative plugin specs with automatic lazy-loading
- **lazy-lock.json**: Pins plugin versions (67 plugins) for reproducibility
- **Mason**: Automatic LSP server, linter, and formatter installation

### Performance Optimizations
- Disabled RTP plugins: gzip, tarPlugin, tohtml, tutor, zipPlugin
- Lazy-loading enabled by default (except custom plugins)
- Plugin checker runs automatically to detect updates

### Special Features
- **Persistent Tmux Sessions**: Automatic recovery via resurrect/continuum
- **Virtual Environment Support**: Venv selector for Python notebooks
- **Floating Window Claude Code**: Integrated AI assistance without context switching
- **Molten Virtual Text**: Code cell output shown inline with virtual text
- **Quarto + Molten**: Execute Python/R/Rust code in markdown files

## Recent Changes & Git Context
- Latest: "add cc" (Claude Code integration)
- Focus areas: AI assistant integration, Avante updates, GPT-5 support

## Repository Status
- Branch: main
- Modified: `nvim/lazy-lock.json` (plugin versions)
- `.gitignore` excludes: `lazy-lock.json`, `lazyvim.json` (to reduce conflicts)
