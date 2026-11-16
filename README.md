# Lightweight macOS bootstrap

This `~/.config` repository sets up a macOS workstation with the same intent as
the Windows dotfiles bootstrap: small, fast native tools, keyboard-first desktop
control, and repo-managed config that can be safely re-applied.

## Current programs

| Role | Program |
| --- | --- |
| Package manager | Homebrew |
| Tiling window manager | Aerospace, with existing Yabai/SKHD configs preserved |
| Terminal | macOS Terminal + zsh |
| Editor | Neovim |
| Launcher / search | Built-in macOS Spotlight |
| Clipboard history | Maccy |
| Screenshots | Shottr |
| Browser | Zen Browser |
| Media / PDF text | VLC, Poppler |
| File manager | `lf`, with Yazi available |

## Installation

From this repository:

```sh
./install.sh
```

The installer:

- Installs Homebrew if it is missing
- Runs `brew bundle` against `programs/Brewfile`
- Installs or updates the OpenAI Codex CLI when `npm` is available
- Keeps the repo as `~/.config`; app folders like `aerospace`, `lf`, `nvim`,
  `skhd`, `yabai`, and `zsh` already live at their target paths
- Symlinks only files that macOS expects outside `~/.config`, currently
  `~/.zshrc`
- Backs up existing files before replacing them
- Applies conservative macOS defaults for Finder, Dock, keyboard repeat, and
  screenshots

## Desktop Controls

Aerospace mirrors the Windows Komorebi bindings where macOS allows it:

- `Alt+H/J/K/L` focuses windows
- `Alt+Shift+H/J/K/L` moves windows
- `Alt+Shift+-/=` resizes
- `Alt+1..9` switches workspaces
- `Alt+Shift+1..9` moves windows across workspaces
- `Alt+Shift+F` toggles fullscreen

macOS keeps some global shortcuts reserved. If a binding does not work, check
**System Settings -> Keyboard -> Keyboard Shortcuts** and grant Accessibility
permission to Aerospace.

## Layout

| Path | Purpose |
| --- | --- |
| `programs/Brewfile` | Homebrew formulae and casks |
| `install.sh` | Fresh-machine bootstrap |
| `aerospace/aerospace.toml` | Aerospace tiling configuration |
| `lf/` | `lf` file manager config |
| `nvim/` | Neovim config |
| `skhd/` | SKHD hotkeys |
| `yabai/` | Yabai config |
| `zsh/` | zsh modules sourced by `~/.zshrc` |
