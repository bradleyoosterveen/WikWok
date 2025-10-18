import json

with open('.fvmrc', 'r') as file:
    data = json.load(file)

version = data['flutter']

print(version)