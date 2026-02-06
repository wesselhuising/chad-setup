# Chad Setup

This repository contains a personal development environment setup, primarily focused on Neovim, tmux, and other command-line tools. It is configured for both macOS and a specific Linux environment.

## Overview

This setup includes configurations for:
- **Neovim:** A highly customized Neovim setup using `lazy.nvim` for plugin management.
- **Tmux:** Terminal multiplexer configuration with plugins.
- **Alacritty:** A fast, cross-platform, OpenGL terminal emulator.
- **Lazygit:** A simple terminal UI for git commands.
- **Shell:** Bash configuration with useful aliases and settings.

## Prerequisites

### macOS
- [Homebrew](https://brew.sh/)
- `git`
- `curl`

### Linux (Debian-based)
- `apt`
- `git`
- `curl`

## Installation

### macOS
1. Clone this repository.
2. Run `make install-osx`.

### Linux
This setup is tailored for a specific machine environment and includes user/group ownership changes.
1. Clone this repository.
2. Run `make install-linux`.