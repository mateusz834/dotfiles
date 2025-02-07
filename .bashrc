#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if  [ -f /usr/share/git/completion/git-prompt.sh ]; then
	source /usr/share/git/completion/git-prompt.sh
	export PS1='[\u@\h \W $(__git_ps1 "(%s)")]\$ '
elif [ -f /etc/bash_completion.d/git-prompt ]; then
	source /etc/bash_completion.d/git-prompt
	export PS1='[\u@\h \W $(__git_ps1 "(%s)")]\$ '
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

alias gitdotfiles='git --git-dir=$HOME/.local/share/git-dotfiles --work-tree=$HOME'

alias act="act --container-daemon-socket $XDG_RUNTIME_DIR/podman/podman.sock"
