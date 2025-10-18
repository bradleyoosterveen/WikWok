import os
import uuid

def set_output(name, value):
    with open(os.environ['GITHUB_OUTPUT'], 'a') as fh:
        fh.write(f'{name}={value}\n')