#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=nvim
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$HOME/.local/bin:$GOBIN:$PATH"

# for podman (systemctl enable --now --user podman.socket)
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
