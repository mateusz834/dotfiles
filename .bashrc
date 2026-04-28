#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# To setup this dotfiles run (in $HOME):
#
#	jj git init --colocate .
#	jj git remote add origin git@github.com:mateusz834/dotfiles.git
#	jj git fetch
#	jj bookmark track master
#	jj new master
#
# On now on use jjdotfiles to manage the dotfiles repo.

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

# Alias for jj that disallows use of jj for the $HOME dotfiles repo,
# to manipulate dotfiles repo use jjdotfiles.
#
# To run without this wrapper use `command jj <args>`
jj() {
	if [[ "$OSTYPE" == linux* ]]; then
		# On linux create mount namespace, that hides ~/.jj and ~/.git contents.
		unshare --user --map-root-user --mount -- bash -c '
			mount -t tmpfs tmpfs "$HOME/.jj"
			mount -t tmpfs tmpfs "$HOME/.git"
			exec jj "$@"
		' bash "$@"
	else
		# On other systems, without namespaces, just change the permissions.
		local jj_mode git_mode status

		if [[ "$OSTYPE" == darwin* ]]; then
		    jj_mode=$(stat -f '%Lp' "$HOME/.jj") || return
		    git_mode=$(stat -f '%Lp' "$HOME/.git") || return
		else
		    jj_mode=$(stat -c '%a' "$HOME/.jj") || return
		    git_mode=$(stat -c '%a' "$HOME/.git") || return
		fi

		chmod 000 "$HOME/.jj" "$HOME/.git" || return

		command jj "$@"
		status=$?

		chmod "$jj_mode" "$HOME/.jj"
		chmod "$git_mode" "$HOME/.git"

		return "$status"
	fi
}

# https://www.reddit.com/r/bash/comments/oinauf/comment/lb9xhi5
function _compalias() {
    local name val valarr fn
    name="${COMP_WORDS[0]}"
    val="${BASH_ALIASES[$name]}"

    [ -z "$val" ] && return 1
    read -ra valarr <<< "$val"
    COMP_WORDS=("${valarr[@]}" "${COMP_WORDS[@]:1}")
    COMP_LINE="${COMP_LINE//$name/$val}"
    COMP_CWORD="$((${#COMP_WORDS[@]} - 1))"
    COMP_POINT="${#COMP_LINE}"

    # regex not perfect but good enough for 99%
    # fn="$(complete -p "${COMP_WORDS[0]}" | grep -Po -- '-F\s+\K\w+')"
	#
	# Replaced grep (above) with sed, for MacOS support.
	fn="$(complete -p "${COMP_WORDS[0]}" | sed -n 's/.*-F \([^ ]*\).*/\1/p')"

    # [-1] is generally faster than [$COMP_CWORD]
    "$fn" "${COMP_WORDS[0]}" "${COMP_WORDS[-1]}" "${COMP_WORDS[-2]}"

}

function compalias() {
    builtin alias "$@"
    # nospace to prevent 2 spaces if default completion adds one
    complete -o nospace -F _compalias "${@%%=*}"
}

compalias jjdotfiles="command jj --repository $HOME"
