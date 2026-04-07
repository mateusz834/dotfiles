#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# To setup this dotfiles run (in $HOME):
#
# jj git init --colocate .
# jj git remote add origin git@github.com:mateusz834/dotfiles.git
# jj git fetch
# jj bookmark track master
# jj new master

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Ignore the dotfiles repo at $HOME in for every
# other repo display the git status.
IGNORED_REPO="$HOME"
function set_custom_ps1() {
    local git_root
    # Find the root of the current git repo (if any)
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ "$git_root" == "$IGNORED_REPO" ]]; then
        PS1='[\u@\h \W]\$ '
    else
		PS1='[\u@\h \W $(__git_ps1 "(%s)")]\$ '
    fi
}

if  [ -f /usr/share/git/completion/git-prompt.sh ]; then
	source /usr/share/git/completion/git-prompt.sh
	PROMPT_COMMAND=set_custom_ps1
elif [ -f /etc/bash_completion.d/git-prompt ]; then
	source /etc/bash_completion.d/git-prompt
	PROMPT_COMMAND=set_custom_ps1
fi

bind -m vi-command '"\C-o": "\C-z\ec\C-z"'
bind -m vi-insert '"\C-o": "\C-z\ec\C-z"'

if  [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
	source /usr/share/doc/fzf/examples/key-bindings.bash ]
elif [ -f /usr/share/fzf/key-bindings.bash ]; then
	source /usr/share/fzf/key-bindings.bash
fi

export HISTSIZE=10000
export HISTFILESIZE=10000
# To avoid saving consecutive identical commands, and commands that start with a space:
export HISTCONTROL=ignoreboth

alias grep='grep --color'
alias ip='ip -c'

alias json-pretty='python3 -m json.tool'
alias http-server='python3 -m http.server --bind 127.0.0.1'

alias act="act --container-daemon-socket $XDG_RUNTIME_DIR/podman/podman.sock"
