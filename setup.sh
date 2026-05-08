#!/bin/zsh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "linked $dst"
}

link zshrc            ~/.zshrc
link tmux.conf        ~/.tmux.conf
link starship.toml    ~/.config/starship.toml
link ghostty-config   ~/.config/ghostty/config
