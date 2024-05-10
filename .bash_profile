#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=nvim
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# if WSL2
if [[ $WSL_DISTRO_NAME ]]; then
	# WLS2 has a bunch of folders in $PATH, which cause slow nvim start.
	export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/home/mateusz/.dotnet/tools"
	export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
fi

export PATH="$HOME/.local/bin:$GOBIN:$PATH"

# for podman (systemctl enable --now --user podman.socket)
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
