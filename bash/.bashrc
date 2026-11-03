# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# fnm (Node.js version manager) — load before the interactive guard so
# non-interactive shells (scripts, opencode bash) also get `node`/`npm`.
case "$(uname -s)" in
  Darwin) export FNM_DIR="$HOME/Library/Application Support/fnm" ;;
  *)      export FNM_DIR="$HOME/.local/share/fnm" ;;
esac
if [ -d "$HOME/.local/bin" ] && command -v fnm >/dev/null 2>&1; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
  esac
  eval "$(fnm env --shell bash)"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -d "$HOME/.local/kitty.app/bin" ]; then
    PATH="$HOME/.local/kitty.app/bin:$PATH"
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Catppuccin Mocha themed prompt (relies on base16-shell palette)
# mauve user@host : blue path green/red $
__prompt_command() {
    local ec=$?
    local pcol='\[\033[01;32m\]'
    [ $ec -ne 0 ] && pcol='\[\033[01;31m\]'
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] ${pcol}\\\$\[\033[00m\] "
}
PROMPT_COMMAND=__prompt_command

if [ "$(uname -s)" = "Darwin" ]; then
    export CLICOLOR=1
    alias ls='ls -G'
else
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
    fi
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alert() {
    local msg
    msg="$(history 1 | sed -e 's/^[ ]*[0-9]*[ ]*//')"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send --urgency=low -i terminal "$msg"
    elif command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"${msg//\"/\\\"}\" with title \"Command finished\""
    fi
}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
    . /usr/local/etc/profile.d/bash_completion.sh
  fi
fi

export PATH="$PATH:$HOME/.local/bin"
# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

if command -v base16_catppuccin-mocha >/dev/null 2>&1; then
  base16_catppuccin-mocha
fi

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
