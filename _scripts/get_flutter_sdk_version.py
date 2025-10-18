import json
import os
import uuid

with open('.fvmrc', 'r') as file:
    data = json.load(file)

version = data['flutter']

print(version)