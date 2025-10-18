import json
import os
import uuid
import set_github_output_value

with open('.fvmrc', 'r') as file:
    data = json.load(file)

version = data['flutter']

set_github_output_value.set_multiline_output('VERSION', version)