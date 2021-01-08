#!/usr/bin/env python

"""
A script to edit an encrypted credentials file.  
Like what rails does.  

Dependencies
- dotenv
- cryptography
"""

import os
import sys
import tempfile
from subprocess import call
from dotenv import load_dotenv
from cryptography.fernet import Fernet

# Load dotenv to get our encryption key
load_dotenv()

# Some vars
EDITOR      = os.environ.get('EDITOR', 'vi')
CRED_FILE   = '.credentials.enc'
ENC_KEY     = str.encode(os.getenv('ENC_KEY'))

def main():
	# Read and decrypt creds file
	decrypted_contents = decrypt(CRED_FILE)

	# Open decrypted content in tmp file
	# Once saved encrypt and write back to creds file
	with tempfile.NamedTemporaryFile(suffix='.tmp.json') as tf:
		# Write decrypted data to temp file
		tf.write(decrypted_contents)
		tf.flush()

		# Open tempfile in editor
		if EDITOR == 'code':
			# Make vs code wait until file is closed
			call([EDITOR, '--wait', tf.name])
		else:
			call([EDITOR, tf.name])

		# Editor is closed, now encrypt and write back to credentials.json
		tf.seek(0)
		encrypt(CRED_FILE, tf.read())


# Encrypt and write data to file
def encrypt(file, data):
	# Ensure we have bytes
	if isinstance(data, str):
		data = str.encode(data)

	fernet = Fernet(ENC_KEY)
	with open(file, 'wb') as f:
		encrypted = fernet.encrypt(data)
		f.write(encrypted)


# Read file and decrypt contents
def decrypt(file):
	fernet = Fernet(ENC_KEY)
	with open(file, 'rb') as f:
		data = f.read()
		return fernet.decrypt(data)


if __name__ == '__main__':
	main()
