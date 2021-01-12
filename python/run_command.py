"""
Runs a command and captures the output
"""
import subprocess

cmd = subprocess.run(["ls", "-ashl"], capture_output=True)
stdout = cmd.stdout.decode()  # bytes => str
