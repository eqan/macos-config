#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backup_stamp="$(date +%Y%m%d%H%M%S)"

info() {
  printf '\033[36m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\033[33mwarning:\033[0m %s\n' "$*" >&2
}

die() {
  printf '\033[31merror:\033[0m %s\n' "$*" >&2
  exit 1
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  die "This bootstrap targets macOS."
fi

if [[ "$(cd "$repo_root" && pwd -P)" != "$(cd "$HOME/.config" && pwd -P)" ]]; then
  warn "This repo is expected to live at ~/.config."
  warn "Current path: $repo_root"
fi

if ! xcode-select -p >/dev/null 2>&1; then
  warn "Xcode Command Line Tools are required. macOS will open the installer now."
  xcode-select --install || true
  warn "Re-run ./install.sh after Command Line Tools finish installing."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

command -v brew >/dev/null 2>&1 || die "Homebrew is still unavailable after installation."

info "Installing packages from programs/Brewfile..."
brew bundle --file "$repo_root/programs/Brewfile"

backup_path() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="${path}.pre-dotfiles-mac.${backup_stamp}"
    mv "$path" "$backup"
    info "Backed up $path -> $backup"
  fi
}

link_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    info "Already linked $target"
    return
  fi
  backup_path "$target"
  ln -s "$source" "$target"
  info "Linked $target"
}

info "Installing files macOS expects outside ~/.config..."
link_file "$repo_root/zsh/.zshrc" "$HOME/.zshrc"

chmod +x "$repo_root/lf/open.sh" "$repo_root/lf/preview.sh"

if command -v npm >/dev/null 2>&1; then
  info "Installing or updating OpenAI Codex CLI..."
  npm install --global @openai/codex@latest
else
  warn "npm is unavailable; skipping OpenAI Codex CLI."
fi

info "Applying lightweight macOS defaults..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

info "Starting GUI utilities when available..."
for app in Maccy Shottr Zen\ Browser; do
  open -gja "$app" >/dev/null 2>&1 || true
done

if command -v aerospace >/dev/null 2>&1; then
  aerospace reload-config >/dev/null 2>&1 || true
  warn "Grant Accessibility permission to Aerospace if tiling shortcuts do not work."
fi

info "Dotfiles macOS bootstrap completed."
