#!/usr/bin/env bash
set -euo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run_as_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

apt_update() {
  run_as_root apt-get update
}

apt_install() {
  run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

apt_has_package() {
  apt-cache show "$1" >/dev/null 2>&1
}

ensure_ubuntu_universe() {
  if [[ -r /etc/os-release ]]; then
    . /etc/os-release
  fi

  if [[ "${ID:-}" != "ubuntu" ]]; then
    return
  fi

  apt_install software-properties-common
  if command_exists add-apt-repository; then
    run_as_root add-apt-repository -y universe
  fi
}

install_core_packages() {
  local packages=(
    apt-transport-https
    bat
    ca-certificates
    curl
    fontconfig
    fonts-jetbrains-mono
    fzf
    git
    gnupg
    gzip
    tar
    tmux
    unzip
    wget
    wl-clipboard
    xclip
    xsel
    zoxide
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  apt_update
  ensure_ubuntu_universe
  apt_update
  apt_install "${packages[@]}"
}

install_eza() {
  if command_exists eza; then
    return
  fi

  if apt_has_package eza; then
    apt_install eza
    return
  fi

  local key_asc key_gpg
  key_asc="$(mktemp)"
  key_gpg="$(mktemp)"

  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc -o "$key_asc"
  gpg --dearmor --yes --output "$key_gpg" "$key_asc"
  run_as_root install -d -m 0755 /etc/apt/keyrings
  run_as_root install -m 0644 "$key_gpg" /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | run_as_root tee /etc/apt/sources.list.d/gierens.list >/dev/null
  run_as_root chmod 0644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

  rm -f "$key_asc" "$key_gpg"

  apt_update
  apt_install eza
}

install_starship() {
  if command_exists starship; then
    return
  fi

  if apt_has_package starship; then
    apt_install starship
    return
  fi

  mkdir -p "$HOME/.local/bin"
  local installer
  installer="$(mktemp)"
  curl -fsSL https://starship.rs/install.sh -o "$installer"
  sh "$installer" --yes --bin-dir "$HOME/.local/bin"
  rm -f "$installer"
}

install_jetbrains_mono_nerd_font() {
  if command_exists fc-match && fc-match "JetBrainsMono Nerd Font Mono" | grep -qi "JetBrains"; then
    return
  fi

  local url tmpdir font_dir
  url="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | awk -F '"' '/browser_download_url/ && $4 ~ /JetBrainsMono\.zip$/ && !url { url=$4 } END { print url }')"
  if [[ -z "$url" ]]; then
    echo "Could not find the latest JetBrainsMono Nerd Font release asset" >&2
    exit 1
  fi

  tmpdir="$(mktemp -d)"
  font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
  mkdir -p "$font_dir"
  curl -fsSL "$url" -o "$tmpdir/JetBrainsMono.zip"
  unzip -o -q "$tmpdir/JetBrainsMono.zip" -d "$font_dir"
  fc-cache -f "$HOME/.local/share/fonts"
  rm -rf "$tmpdir"
}

install_lazygit() {
  if command_exists lazygit; then
    return
  fi

  if apt_has_package lazygit; then
    apt_install lazygit
    return
  fi

  local arch asset_arch url tmpdir
  arch="$(uname -m)"

  case "$arch" in
    x86_64|amd64)
      asset_arch="x86_64"
      ;;
    aarch64|arm64)
      asset_arch="arm64"
      ;;
    *)
      echo "Unsupported architecture for lazygit binary install: $arch" >&2
      exit 1
      ;;
  esac

  url="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | awk -F '"' -v arch="$asset_arch" '/browser_download_url/ && $4 ~ "linux_" arch ".tar.gz$" && !url { url=$4 } END { print url }')"
  if [[ -z "$url" ]]; then
    echo "Could not find a lazygit Linux release for $asset_arch" >&2
    exit 1
  fi

  tmpdir="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"
  rm -rf "$tmpdir"
}

install_ghostty() {
  if command_exists ghostty; then
    return
  fi

  if apt_has_package ghostty; then
    apt_install ghostty
    return
  fi

  if command_exists snap && snap info ghostty >/dev/null 2>&1; then
    run_as_root snap install ghostty --classic
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
}

install_core_packages
install_eza
install_starship
install_jetbrains_mono_nerd_font
install_lazygit
install_ghostty

echo "Linux terminal packages installed."
