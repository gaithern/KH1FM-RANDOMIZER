import os
import shutil
import json
from datetime import datetime

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def list_files_recursive(path='.', filenames=[]):
    for entry in os.listdir(path):
        full_path = os.path.join(path, entry)
        if os.path.isdir(full_path):
            list_files_recursive(full_path)
        else:
            filenames.append(str(full_path).replace("\\", "/"))
    return filenames

def get_mod_yaml_header(seed, slot_name):
    seed_string = hex(int(str(seed).replace("W", ""))).upper().replace("0X", "")
    return f"""title: KH1R {slot_name} {seed_string}
originalAuthor: Gicu
description: Necessary files for KH1FM Archipelago Randomizer.  For more info - kh1fmrando.com
dependencies:
assets:
"""

def remove_path(files, path):
    for i in range(len(files)):
        files[i] = files[i].replace(path, "")

def write_mod_yaml_file(mod_yaml_str):
    with open("./Working/mod.yml", "w") as f:
        f.write(mod_yaml_str)

def zip_directory(directory_path, zip_file_path):
    shutil.make_archive(zip_file_path, 'zip', directory_path)

def create_mod_yaml(seed, slot_name):
    mod_yaml_str = get_mod_yaml_header(seed, slot_name)
    directory_path = './Working/'
    files = list_files_recursive(directory_path)
    remove_path(files, directory_path)
    for file in files:
        if file != "mod.yml":
            mod_yaml_str = mod_yaml_str + """- name: """ + str(file) + """
  method: copy
  source:
  - name: """ + str(file) + """
"""
    write_mod_yaml_file(mod_yaml_str)

def write_mod_zip(settings_file = None):
    settings_data = get_settings_data(settings_file)
    now = datetime.now()
    seed = settings_data["seed"]
    slot_name = ""
    if "slot_name" in settings_data.keys():
        slot_name = settings_data["slot_name"]
    create_mod_yaml(seed, slot_name)
    directory_to_zip = './Working/'
    output_zip_file = './Output/mod_' + now.strftime("%Y%m%d%H%M%S")
    zip_directory(directory_to_zip, output_zip_file)

if __name__=="__main__":
    write_mod_zip()