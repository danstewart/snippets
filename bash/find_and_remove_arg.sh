# A function to find and remove an arg, useful for optional args that can be passed in any position.

function _find_arg() {
	idx=1
	to_remove=0

	for var in "$@"; do
		if [[ $var == '--argname' ]]; then
			found=1	
			to_remove=$idx
		fi
		(( idx++ ))
	done
  
  if [[ $to_remove != 0 ]]; then
	  set -- "${@:1:$to_remove-1}" "${@:$to_remove+1}"
	  to_remove=0
  fi
}
