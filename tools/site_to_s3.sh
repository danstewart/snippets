#!/usr/bin/env bash

"""
Zips up a static site and puts it in S3

Dependencies:
- awscli
"""

BUCKET=""
REGION=""
SRC_DIR=""

site_name="$1"

if [[ -z $site_name ]]; then
	echo "Usage: ./site_to_s3.sh <static dir name>"
	echo ""
	echo "NOTE: It is assumed the prefix in the bucket is the same as the local directory name"
	exit 1
fi

# Ensure we're in the project root
if [[ ! -d $SRC_DIR ]]; then
	echo "Failed to find $SRC_DIR - are you in the project root?"
	exit 1
fi

# We only want the script basename
if [[ $site_name =~ '/' ]]; then
	site_name=$(basename $site_name)
fi

# Bail if dir doesn't exist
if [[ ! -d "$SRC_DIR/$site_name" ]]; then
	echo "Failed to find $SRC_DIR/$site_name - bailing"
	exit 1
fi

aws s3 cp --acl public-read --recursive "$SRC_DIR/$site_name/" "s3://$BUCKET/$site_name"
