#!/usr/bin/env bash

"""
Prepare python project for AWS lambda  

Dependencies:
- awscli
"""

# Exit on failure
set -e

VENV_DIR='venv'
SRC_DIR='src'
LIB_DIR='src/lib'
SCRIPT_DIR='src/scripts'
PACKAGE_DIR="$VENV_DIR/lib/python3.8/site-packages"
REGION='eu-west-1'

# Check for --deploy arg and remove from param list
idx=1
to_remove=0
deploy=0

for var in "$@"; do
	if [[ $var == '--deploy' ]]; then
		deploy=1
		to_remove=$idx
	fi
	(( idx++ ))
done

if [[ $to_remove != 0 ]]; then
	set -- "${@:1:$to_remove-1}" "${@:$to_remove+1}"
	to_remove=0
fi

# Args
script="$1"; shift
extra_files="$@"

if [[ -z $script ]]; then
	echo "Usage: ./zip_lambda.sh <script_name> [--deploy] [file1 file2 ...]"
	echo ""
	echo "Zips up the target script and all dependencies for loading into AWS Lambda"
	echo "NOTE: It is assumed the lambda function has the same name as the script"
	echo ""
	echo "If --deploy is passed then the resulting zip will be automatically deployed to lambda"
	echo ""
	echo "An optional list of additional files to include in the zip can be passed"
	echo "These extra files will be added to the zip in the path provided"
	echo ""
	echo "NOTE: This must be ran from project root"
	exit 1
fi

if [[ ! -d $VENV_DIR || ! -d $SRC_DIR ]]; then
	echo "Failed to find $VENVDIR or $SRC_DIR - are you in the project root?"
	exit 1
fi

# We only want the script basename
if [[ $script =~ '/' ]]; then
	script=$(basename $script .py)
fi

ZIP_NAME="$script-lambda-package.zip"

# venv and pip
source venv/bin/activate
pip3 --quiet install --requirement requirements.txt
deactivate

[[ -f "$ZIP_NAME" ]] && rm -f "$ZIP_NAME"

#== Make our zip ==#
# Add python packages to zip
cd "$PACKAGE_DIR"
zip --quiet --recurse-paths "$ZIP_NAME" .
cd - >/dev/null

# Move zip to project root
mv "$PACKAGE_DIR/$ZIP_NAME" .

# Add .env and script
zip --quiet --grow "$ZIP_NAME" .env
zip --quiet --grow "$ZIP_NAME" .credentials.enc
zip --quiet --grow --junk-paths "$ZIP_NAME" "$SCRIPT_DIR/$script.py"

# Add our packages
cd $SRC_DIR
zip --quiet --recurse-paths --grow "../$ZIP_NAME" lib/*
cd - >/dev/null

# Add any extra files
for file in ${extra_files[@]}; do
	zip --quiet --grow "$ZIP_NAME" "$file"
done


# Move to packages dir
[[ ! -d packages/ ]] && mkdir packages
mv $ZIP_NAME packages/

# Done
echo "Created $ZIP_NAME"

if [[ -n $deploy ]]; then
	aws --region $REGION lambda update-function-code --function-name "$script" --zip-file "fileb://packages/$ZIP_NAME"
else
	echo "Run the following to upload to AWS:"
	echo "aws --region $REGION lambda update-function-code --function-name $script --zip-file fileb://packages/$ZIP_NAME"
fi
