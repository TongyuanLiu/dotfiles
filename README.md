# dotfiles

Mac terminal configuration files managed with symbolic links.

## What's included

| File | Symlink target | Purpose |
|------|---------------|---------|
| `zshrc` | `~/.zshrc` | Zsh shell config — aliases, plugins, prompt |
| `starship.toml` | `~/.config/starship.toml` | Starship prompt theme |
| `ghostty-config` | `~/.config/ghostty/config` | Ghostty terminal emulator config |
| `tmux.conf` | `~/.config/tmux/tmux.conf` | Tmux config — vi keybindings, mouse support |
| `Brewfile` | — | Homebrew packages and casks |

## Setup on a new machine

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```sh
git clone https://github.com/TongyuanLiu/dotfiles.git ~/dotfiles
```

### 3. Install packages

```sh
brew bundle --file ~/dotfiles/Brewfile
```

### 4. Create symbolic links

```sh
# Zsh
ln -sf ~/dotfiles/zshrc ~/.zshrc

# Starship
mkdir -p ~/.config
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

# Ghostty
mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/ghostty-config ~/.config/ghostty/config

# Tmux
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux.conf ~/.config/tmux/tmux.conf
```

### 5. Set up fzf shell integration

```sh
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
```

### 6. Reload the shell

```sh
source ~/.zshrc
```

## Updating

Edit files directly in `~/dotfiles/`. Because symlinks point here, changes take effect immediately (re-source `.zshrc` if needed). Commit and push to keep the repo in sync.
