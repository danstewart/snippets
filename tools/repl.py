"""
Small script to load everything in an interactive session for easier debugging  

Usage:  
python -i repl.py

Dependencies:
- None

Todo:  
Just edit the module names in the imports and the MODS dict
"""

import sys
import json
import importlib

# Import the modules so we can reload
import lib.thing1
import lib.thing2

# Map of modules to classnames
MODS = dict(
	thing1="Thing1",
	thing2="Thing2",
)

# Create our instances
for mod_name, class_name in MODS.items():
	exec(f'globals()["{mod_name}"] = lib.apis.{mod_name}.{class_name}()')

# Reloads a module
def reload(mod_name):
	if class_name := MODS.get(mod_name):
		mod = sys.modules.get(f'lib.apis.{mod_name}')
		importlib.reload(mod)
		exec(f'globals()["{mod_name}"] = lib.apis.{mod_name}.{class_name}()')
	else:
		print(f"ERROR: Do not recognise '{mod_name}'")

# Pretty print JSON
def pretty(data):
	if isinstance(data, str):
		print(json.dumps(json.loads(data), sort_keys=True, indent=2))
	else:
		print(json.dumps(data, sort_keys=True, indent=2))
