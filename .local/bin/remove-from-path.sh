# Remove this script from the PATH env variable to avoid recursively calling this file again.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
IFS=: read -r -d '' -a path_array < <(printf '%s:\0' "$PATH")
export PATH=""
for p in "${path_array[@]}"; do
	if [ "$p" != "$SCRIPT_DIR" ]; then
		if [ "$PATH" == "" ]; then
			PATH="$p"
		else
			PATH="$PATH:$p"
		fi
	fi
done
