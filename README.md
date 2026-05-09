# dotfiles

Terminal configuration files for macOS and Ubuntu/Linux, managed with symbolic links.

## Layout

| Folder | Purpose |
|--------|---------|
| `mac/` | macOS terminal setup using Homebrew |
| `linux/` | Ubuntu/Linux terminal setup using apt-friendly paths and fallbacks |

Shared file names are kept the same inside each folder so the setup scripts can link the matching OS version.

## What's included

| File | Symlink target | Purpose |
|------|---------------|---------|
| `zshrc` | `~/.zshrc` | Zsh config: aliases, plugins, fzf, zoxide, Starship |
| `starship.toml` | `~/.config/starship.toml` | Starship prompt theme |
| `ghostty-config` | `~/.config/ghostty/config` | Ghostty terminal emulator config |
| `tmux.conf` | `~/.tmux.conf` | Tmux config: vi keybindings, mouse support, clipboard |

## Ubuntu/Linux setup

Clone the repo:

```sh
git clone https://github.com/TongyuanLiu/dotfiles.git ~/dotfiles
```

Run the setup script:

```sh
~/dotfiles/setup.sh
```

On Linux this installs the terminal packages first, then creates symlinks. It uses apt for core packages and fallback installers for tools that are often missing from Ubuntu apt sources:

- `eza`: official eza apt repository
- `starship`: official Starship install script into `~/.local/bin`
- `lazygit`: latest GitHub release into `~/.local/bin`
- `ghostty`: apt or snap when available, otherwise the Ghostty Ubuntu package installer
- JetBrainsMono Nerd Font: latest Nerd Fonts release into `~/.local/share/fonts`

Or call the Linux setup directly:

```sh
~/dotfiles/linux/setup.sh
```

To relink configs without installing packages:

```sh
DOTFILES_SKIP_INSTALL=1 ~/dotfiles/setup.sh
```

Start zsh or reload it:

```sh
exec zsh
```

If you are already inside zsh, use:

```sh
source ~/.zshrc
```

Optional: make zsh your login shell:

```sh
chsh -s "$(command -v zsh)"
```

## macOS setup

Clone the repo:

```sh
git clone https://github.com/TongyuanLiu/dotfiles.git ~/dotfiles
```

Run the setup script:

```sh
~/dotfiles/setup.sh
```

On macOS this installs Homebrew if needed, runs the Brewfile, sets up fzf integration, then creates symlinks.

Or call the macOS setup directly:

```sh
~/dotfiles/mac/setup.sh
```

To relink configs without installing packages:

```sh
DOTFILES_SKIP_INSTALL=1 ~/dotfiles/setup.sh
```

Start zsh or reload it:

```sh
exec zsh
```

If you are already inside zsh, use:

```sh
source ~/.zshrc
```

## Notes

Setup scripts back up an existing non-symlink target before replacing it, using a suffix like `.backup.20260509163000`.

On Ubuntu, `bat` may be installed as `batcat`; the Linux zsh config handles both. The tmux Linux config copies to the clipboard with `wl-copy`, `xclip`, or `xsel`, depending on what is installed.

## Updating

Edit files directly in `~/dotfiles/mac/` or `~/dotfiles/linux/`. Because symlinks point here, changes take effect immediately after reloading the relevant program.
