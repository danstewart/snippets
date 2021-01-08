"""
Transfers CLI args in the format `key1=val1 key2=val2 ...` into a dict for kwargs  
"""

import sys

# Grab all args apart from the first
args = sys.argv[1:]
try:
	# Munge into dict
	args = { k: v for k, v in [ arg.split('=') for arg in args ] }
except Exception:
	# Handle error
	print("Invalid arguments, should be key value pairs separated with '='")
	sys.exit(1)

print(args)
