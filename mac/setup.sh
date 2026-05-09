#!/bin/zsh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ "${EUID:-$(id -u)}" -eq 0 && -n "${SUDO_USER:-}" ]]; then
  echo "Run this script as your normal user, not with sudo. It will ask for sudo when needed." >&2
  exit 1
fi

if [[ "${DOTFILES_SKIP_INSTALL:-0}" != "1" ]]; then
  "$DOTFILES/install-packages.sh"
fi

link() {
  local src="$DOTFILES/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "backed up $dst -> $backup"
  fi

  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

link zshrc            ~/.zshrc
link tmux.conf        ~/.tmux.conf
link starship.toml    ~/.config/starship.toml
link ghostty-config   ~/.config/ghostty/config
