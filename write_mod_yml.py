import os
from pprint import pprint

def list_files_recursive(path='.', filenames=[]):
    for entry in os.listdir(path):
        full_path = os.path.join(path, entry)
        if os.path.isdir(full_path):
            list_files_recursive(full_path)
        else:
            filenames.append(str(full_path).replace("\\", "/"))
    return filenames

def get_mod_yaml_header():
    return """title: Test Mod for KH1 Randomizer
originalAuthor: Gicu
description: Test Mod for KH1 Randomizer
dependencies:
assets:
"""

def remove_path(files, path):
    for i in range(len(files)):
        files[i] = files[i].replace(path, "")

def write_mod_yaml_file(mod_yaml_str):
    with open("./Output/mod.yml", "w") as f:
        f.write(mod_yaml_str)

def create_mod_yaml():
    mod_yaml_str = get_mod_yaml_header()
    directory_path = './Output/'
    files = list_files_recursive(directory_path)
    remove_path(files, directory_path)
    for file in files:
        mod_yaml_str = mod_yaml_str + """- name: """ + str(file) + """
  method: copy
  source:
  - name: """ + str(file) + """
"""
    write_mod_yaml_file(mod_yaml_str)

if __name__=="__main__":
    create_mod_yaml()