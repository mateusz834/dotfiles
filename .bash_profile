#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=nvim
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$HOME/.local/bin:$GOBIN:$PATH"