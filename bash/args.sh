#!/usr/bin/env bash

# Arg parse
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--first) first=$2; shift ;;
		--second) second=$2; shift ;;
		-h|--help) help=1 ;;
		-f|--force) force=1 ;;
		--) shift; break ;;
	esac

	shift
done
