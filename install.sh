#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
OS="${DOTFILES_OS:-$(uname -s)}"
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backup"
BACKUP="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
SKIP_DEPS=0

usage() {
    cat <<'EOF'
Usage: ./install.sh [--dry-run] [--skip-deps]

  --dry-run    Show what would change without touching anything
  --skip-deps  Do not clone tmux plugins / the kitty search kitten
EOF
}

for arg in "$@"; do
    case "$arg" in
        --dry-run)   DRY_RUN=1 ;;
        --skip-deps) SKIP_DEPS=1 ;;
        -h|--help)   usage; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
    esac
done

LINKS=(
    "bash/.bashrc                                  .bashrc"
    "bash/.profile                                 .profile"
    "nvim/.config/nvim                             .config/nvim"
    "tmux/.tmux.conf                               .tmux.conf"
    "kitty/.config/kitty/kitty.conf                .config/kitty/kitty.conf"
    "themes/.config/base16-shell                   .config/base16-shell"
    "vim/.vimrc                                    .vimrc"
)

say()  { printf '%s\n' "$*"; }
info() { printf '  %s\n' "$*"; }

backup_path() {
    local dest="$1"
    local rel="${dest#"$HOME"/}"
    local target="$BACKUP/$rel"
    mkdir -p "$(dirname "$target")"
    mv "$dest" "$target"
    info "backed up: ~/$rel -> $target"
}

link_path() {
    local src="$REPO/$1" dest="$HOME/$2"

    if [ ! -e "$src" ]; then
        say "missing source: $1" >&2
        return 1
    fi

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        info "ok: ~/$2"
        return 0
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            info "would back up: ~/$2"
        else
            backup_path "$dest"
        fi
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        info "would link: ~/$2 -> $src"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    info "linked: ~/$2"
}

clone_pinned() {
    local dest="$1" url="$2" sha="$3" name="$4"

    if [ -d "$dest/.git" ]; then
        info "ok: $name"
        return 0
    fi
    if [ -e "$dest" ]; then
        info "skip: $name exists but is not a git clone"
        return 0
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        info "would clone: $name"
        return 0
    fi

    info "cloning: $name"
    mkdir -p "$(dirname "$dest")"
    git clone --quiet "$url" "$dest"
    git -C "$dest" checkout --quiet "$sha"
}

set_base16_theme() {
    local theme="${BASE16_THEME:-catppuccin-mocha}"
    local target="$HOME/.config/base16-shell/scripts/base16-$theme.sh"
    local dest="$HOME/.base16_theme"

    if [ ! -f "$target" ]; then
        say "base16 theme not found: $target" >&2
        return 1
    fi
    if [ -L "$dest" ]; then
        current="$(readlink "$dest")"
        if [ "${current//\/\//\/}" = "$target" ]; then
            info "ok: ~/.base16_theme -> $theme"
            return 0
        fi
    fi
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            info "would back up: ~/.base16_theme"
        else
            backup_path "$dest"
        fi
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
        info "would link: ~/.base16_theme -> $target"
        return 0
    fi
    ln -sf "$target" "$dest"
    info "linked: ~/.base16_theme -> $theme"
}

say "dotfiles: $REPO"
say "platform: $OS"
say ""
say "Linking:"
for entry in "${LINKS[@]}"; do
    read -r src dest <<<"$entry"
    link_path "$src" "$dest"
done

say ""
say "Theme:"
set_base16_theme

if [ "$SKIP_DEPS" -eq 0 ]; then
    say ""
    say "Dependencies:"
    if command -v git >/dev/null 2>&1; then
        clone_pinned "$HOME/.tmux/plugins/tmux-resurrect" \
            "https://github.com/tmux-plugins/tmux-resurrect.git" \
            "cff343cf9e81983d3da0c8562b01616f12e8d548" \
            "tmux-resurrect"
        clone_pinned "$HOME/.tmux/plugins/tmux-continuum" \
            "https://github.com/tmux-plugins/tmux-continuum.git" \
            "0698e8f4b17d6454c71bf5212895ec055c578da0" \
            "tmux-continuum"
        clone_pinned "$HOME/.config/kitty/kitty_search" \
            "https://github.com/trygveaa/kitty-kitten-search.git" \
            "992c1f3" \
            "kitty search kitten"
    else
        info "git not found; skipped tmux plugins and kitty kitten"
    fi
fi

say ""
say "Checks:"
missing=()
for cmd in git nvim vim tmux kitty fzf rg fd; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if [ "${#missing[@]}" -gt 0 ]; then
    info "missing commands: ${missing[*]}"
else
    info "all expected commands found"
fi
font_found=0
if command -v fc-list >/dev/null 2>&1; then
    families="$(fc-list : family 2>/dev/null || true)"
    case "$families" in
        *"JetBrainsMono Nerd Font"*) font_found=1 ;;
    esac
fi
if [ "$font_found" -eq 0 ] && [ "$OS" = "Darwin" ]; then
    font_file="$(find "$HOME/Library/Fonts" /Library/Fonts -iname '*JetBrainsMono*Nerd*' -print 2>/dev/null | sed -n '1p')"
    [ -n "$font_file" ] && font_found=1
fi
if [ "$font_found" -eq 1 ]; then
    info "JetBrainsMono Nerd Font found"
else
    info "JetBrainsMono Nerd Font not found (install it for kitty/nvim icons)"
fi

say ""
say "Git identity (not managed by this repo):"
if [ -e "$HOME/.gitconfig" ]; then
    info "~/.gitconfig already exists"
else
    info "copy git/.gitconfig.example to ~/.gitconfig and set user.name / user.email"
fi

say ""
if [ "$DRY_RUN" -eq 1 ]; then
    say "Dry run complete. Re-run without --dry-run to apply."
else
    say "Done."
    [ -d "$BACKUP" ] && say "Backups: $BACKUP"
    say "Restart the shell: exec bash"
    say "Reload tmux: tmux source-file ~/.tmux.conf"
    say "Open nvim and run :Lazy restore if plugins are missing."
fi
