#!/usr/bin/env bash

# Source tools/set_path.sh

if [[ "$BASH_SOURCE" == "$0" ]]; then
	echo "Source me, do not run directly: source set_path.sh"
	exit 1
fi

# Export PYTHONPATH
current_dir=$(realpath $(dirname "$BASH_SOURCE"))
src_dir=$(realpath "$current_dir/../src/")
export PYTHONPATH="$src_dir:$PYTHON_PATH"
