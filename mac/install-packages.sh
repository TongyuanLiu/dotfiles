#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

load_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

load_brew_shellenv

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_shellenv
fi

brew bundle --file "$DOTFILES/Brewfile"

fzf_installer="$(brew --prefix)/opt/fzf/install"
if [[ -x "$fzf_installer" ]]; then
  "$fzf_installer" --key-bindings --completion --no-update-rc
fi

echo "macOS terminal packages installed."
