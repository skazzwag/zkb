# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# aliases for git
alias gco='git checkout'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gd='git diff'
alias gl='git log'
alias gr='git reset'
alias gb='git branch'

# Git with fzf functions
unalias gfa 2>/dev/null  # Remove alias of gfa='command git fetch --all --prune'
gfa() {
  git ls-files --others --modified --exclude-standard \
    | fzf -m \
        --header '↑↓ move | Tab select | Shift+↑↓ preview | Ctrl-O Hunk | Alt-W wrap | Enter stage | Esc cancel' \
        --preview '
          if git ls-files --error-unmatch -- {} >/dev/null 2>&1; then
            git diff --color=always -- {}
          elif command -v bat >/dev/null 2>&1; then
            bat --color=always --style=numbers -- {}
          else
            sed -n "1,200p" -- {}
          fi
        ' \
        --bind 'ctrl-o:execute(tmux new-window hunk diff -- {})' \
        --bind 'alt-w:toggle-preview-wrap' \
    | xargs -r git add
}

gfco() {
  git ls-files --others --modified --exclude-standard \
    | fzf -m \
        --header '↑↓ move | Tab select | Shift+↑↓ preview | Ctrl-O Hunk | Alt-W wrap | Enter checkout | Esc cancel' \
        --preview '
          if git ls-files --error-unmatch -- {} >/dev/null 2>&1; then
            git diff --color=always -- {}
          elif command -v bat >/dev/null 2>&1; then
            bat --color=always --style=numbers -- {}
          else
            sed -n "1,200p" -- {}
          fi
        ' \
        --bind 'ctrl-o:execute(tmux new-window hunk diff -- {})' \
        --bind 'alt-w:toggle-preview-wrap' \
    | xargs -r git checkout --
}

gfr() {
  git diff --cached --name-only \
    | fzf -m \
        --header '↑↓ move | Tab select | Shift+↑↓ preview | Ctrl-O Hunk | Alt-W wrap | Enter unstage | Esc cancel' \
        --preview 'git diff --cached --color=always -- {}' \
        --bind 'ctrl-o:execute(tmux new-window hunk diff --cached -- {})' \
        --bind 'alt-w:toggle-preview-wrap' \
    | xargs -r git restore --staged --
}

gfl() {
  git log --color=always \
      --format=$'%H\t%C(auto)%h %C(dim)%ad%C(reset) %C(auto)%d%C(reset) %s %C(dim)<%an>%C(reset)' \
      --date=short \
    | fzf \
        --ansi \
        --delimiter=$'\t' \
        --with-nth=2.. \
        --header '↑↓ move | Shift+↑↓ preview | Ctrl-O full diff | Alt-W wrap | Enter show | Esc cancel' \
        --preview 'git show --color=always --stat --patch {1}' \
        --bind 'ctrl-o:execute(tmux new-window hunk show {1})' \
        --bind 'alt-w:toggle-preview-wrap' \
    | cut -f1 \
    | xargs -r git show
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
  fi
fi

# Add shell completions for uv
. "$HOME/.local/bin/env"
eval "$(uvx --generate-shell-completion bash)"
eval "$(uv generate-shell-completion bash)"

# Set editor to fresh
export EDITOR="fresh --wait"
export VISUAL="fresh --wait"

# DuckDB alias
export PATH="/home/zak/.duckdb/cli/latest":$PATH

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

# Direnv to make env variables per project easy
eval "$(direnv hook bash)"

# Additions to PATH
export PATH=$HOME/.opencode/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH='/home/zak/.hunk/bin':"$PATH"
