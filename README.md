# dotfiles

Portable dotfiles for bash, Neovim, Vim, tmux, kitty, and base16 theming.
Works on Linux and macOS. Symlink-based, with no external dotfile manager.

## What's included

| Package   | Contents |
|-----------|----------|
| `bash/`   | `.bashrc`, `.profile`: PATH, prompt, aliases, base16, fnm/mise |
| `nvim/`   | Neovim config: lazy.nvim, LSP, completion, Telescope, treesitter, oil, nvim-tree, toggleterm, conform, git signs, tokyonight |
| `vim/`    | Dependency-free `.vimrc` mirroring the Neovim options and keymaps |
| `tmux/`   | `.tmux.conf`: truecolor, pane borders, resurrect + continuum |
| `kitty/`  | `kitty.conf`: JetBrainsMono Nerd Font, transparency, search kitten |
| `themes/` | Vendored `base16-shell` (Catppuccin Mocha by default) |
| `git/`    | `.gitconfig.example` only; identity is never tracked |
| `packages/` | Reference package lists for Homebrew and apt |

`nvim/lazy-lock.json` is committed so plugin versions are reproducible.

## Install

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

The installer:

1. Backs up conflicting files to
   `~/.local/state/dotfiles/backup/<timestamp>/`.
2. Symlinks the tracked configs into `$HOME`.
3. Recreates `~/.base16_theme` as a symlink to the selected theme.
4. Clones the pinned tmux plugins and the kitty search kitten if missing
   (`--skip-deps` disables this).
5. Checks for missing commands and the Nerd Font.
6. Never touches `~/.gitconfig`.

It is idempotent: correct symlinks are left alone.

## Requirements

Core commands: `git`, `nvim`, `vim`, `tmux`, `kitty`, `fzf`, `rg`, `fd`.

### macOS

```sh
brew bundle --file=packages/Brewfile
```

Homebrew installs the Nerd Font cask and the terminal tools. macOS defaults to
zsh; either change the login shell to bash:

```sh
chsh -s /bin/bash
```

or source the bash config from your zsh startup file. The config targets bash
3.2+, so the system bash works; a newer Homebrew bash is also fine.

### Linux

Packages are listed in `packages/apt.txt`. On Debian/Ubuntu, `fd-find`
installs the binary as `fdfind`; install `fd` upstream or add a symlink.
Use a recent Neovim (0.10+) from upstream rather than an old distro package.
Install JetBrainsMono Nerd Font from the Nerd Fonts release page or your
distro's font package.

### FZF/Ripgrep/FD

The shell config uses these tools when present. No separate config files are
needed.

## First run

Neovim bootstraps `lazy.nvim` and installs plugins on first launch. To match
the committed lockfile, run `:Lazy restore` after the first start.

tmux plugins are loaded with `run-shell`, so TPM is not required. Reload tmux
with `tmux source-file ~/.tmux.conf`.

## Git identity

Copy the example and edit it locally:

```sh
cp git/.gitconfig.example ~/.gitconfig
```

Set your real name and email there. The file is intentionally not symlinked,
so your identity stays out of this public repository.

## Theme

`.bashrc` sources `base16-shell` and applies `base16_catppuccin-mocha`. Any
generated function, such as `base16_gruvbox-dark-hard`, switches the terminal
palette and updates `~/.base16_theme`. To change the default, edit the
`base16_catppuccin-mocha` line in `bash/.bashrc`.

The kitty theme follows the terminal palette. Desktop-specific themes (GTK,
icons, cursors) are not included.

## Editing

1. Edit the file under `~/dotfiles/<package>/...`.
2. Changes take effect immediately through the symlinks.
3. If you add a new top-level path, add it to `LINKS` in `install.sh` and
   re-run the installer.

## Not tracked

- `~/.gitconfig` and personal identity.
- Desktop/WM configs (i3, rofi, picom, GTK, hardware-tuned scripts). These are
  machine-specific and deliberately kept out of this repository.
- tmux resurrect snapshots (`~/.tmux/resurrect`), which contain session state.
- `kitty_search/`, cloned from upstream.
- Neovim runtime data, caches, and plugin directories.

## Scope

This repository is intentionally limited to portable terminal tooling and
theming. Machine-specific hardware, desktop environment, and application
configuration are out of scope.
