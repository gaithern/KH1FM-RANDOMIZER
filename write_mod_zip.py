import shutil
from datetime import datetime

from globals import BASE_DIR, read_json, write_file

def get_mod_yaml_header(seed, slot_name):
    seed_string = hex(int(str(seed).replace("W", ""))).upper().replace("0X", "")
    return f"""title: KH1R {slot_name} {seed_string}
originalAuthor: Gicu
description: Necessary files for KH1FM Archipelago Randomizer.  For more info - kh1fmrando.com
dependencies:
- name: gaithern/kh1-lua-library
assets:
"""

def remove_path(files, path):
    path = str(path)
    for i in range(len(files)):
        files[i] = files[i].replace(path, "")

def zip_directory(directory_path, zip_file_path):
    shutil.make_archive(zip_file_path, 'zip', directory_path)

def create_mod_yaml(seed, slot_name):
    mod_yaml_str = get_mod_yaml_header(seed, slot_name)
    working_dir = BASE_DIR / "Working"
    
    # rglob("*") finds all files recursively
    for file_path in working_dir.rglob("*"):
        if file_path.is_file() and file_path.name != "mod.yml":
            # Get path relative to "Working" folder
            rel_path = file_path.relative_to(working_dir).as_posix()
            
            mod_yaml_str += f"- name: {rel_path}\n"
            mod_yaml_str += f"  method: copy\n"
            mod_yaml_str += f"  source:\n"
            mod_yaml_str += f"  - name: {rel_path}\n"
            
    write_file(working_dir / "mod.yml", mod_yaml_str)

def write_mod_zip(settings_file):
    settings_data = read_json(settings_file)
    now = datetime.now()
    seed = settings_data["seed"]
    slot_name = ""
    if "slot_name" in settings_data:
        slot_name = settings_data["slot_name"]
    create_mod_yaml(seed, slot_name)
    directory_to_zip = BASE_DIR / "Working"
    output_zip_file = BASE_DIR / "Output" / f"mod_{now.strftime('%Y%m%d%H%M%S')}"
    zip_directory(directory_to_zip, output_zip_file)