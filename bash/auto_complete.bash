#!/usr/bin/env bash

# Source this to enable autocompletion for the script 'script_name'

_make_completions() {
	local cur prev

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	case ${COMP_CWORD} in
		# List of subcommands
		1)
			COMPREPLY=($(compgen -W "init make-config import export" -- ${cur}))
			;;
		2)
			# Auto complete for the individual subcommands
			case ${prev} in
				import)
					COMPREPLY=($(compgen -A directory -- ${cur}))
					;;
				export)
					COMPREPLY=($(compgen -A directory -- ${cur}))
					;;
				init)
					COMPREPLY=($(compgen -W "password" -- ${cur}))
					;;
			esac
			;;
		*)
			COMPREPLY=()
			;;
	esac
}

complete -F _make_completions script_name
