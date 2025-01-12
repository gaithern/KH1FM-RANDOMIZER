import tkinter as tk
from tkinter import filedialog
import csv
import json
from pprint import pprint
import os

from definitions import synthesis_item_ids

root = tk.Tk()
root.withdraw()

def get_kh1_data_path():
    kh1_data_path = None
    while not kh1_data_path:
        kh1_data_path = filedialog.askdirectory()
        if not kh1_data_path:
            print("Error, please select a valid KH1 data path")
    return kh1_data_path

def get_enemy_drop_definitions():
    with open('./KH1FM Documentation - Enemy Stats and Drops.csv', mode = 'r') as file:
        enemy_drop_definitions = []
        enemy_drop_data = csv.DictReader(file)
        for line in enemy_drop_data:
            enemy_drop_definitions.append(line)
    return enemy_drop_definitions

def get_enemy_data(kh1_data_path, file_name):
    with open(kh1_data_path + "/" + file_name, mode = 'rb') as file:
        return bytearray(file.read())

def remove_enemy_synth_drops(enemy_bytes, enemy_drop_definitions):
    for enemy_drop_definition in enemy_drop_definitions:
        if enemy_drop_definition["Notes"].startswith("Drop"):
            if int(enemy_drop_definition["Value"]) in synthesis_item_ids:
                offset = int(enemy_drop_definition["Offset"], 16)
                enemy_bytes[offset-4] = 0
                enemy_bytes[offset-3] = 0
                enemy_bytes[offset-2] = 0
                enemy_bytes[offset-1] = 0
                enemy_bytes[offset] = 0
                enemy_bytes[offset+1] = 0
                enemy_bytes[offset+2] = 0
                enemy_bytes[offset+3] = 0
    return enemy_bytes

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def write_enemy_mdls(enemy_bytes, file_name):
    with safe_open_wb('./Output/' + file_name) as file:
        file.write(enemy_bytes)

def get_mod_yml_string(enemy_drop_definitions):
    written_enemy_mdls_yaml_data = []
    mod_yml_str = """"""
    for enemy_drop_definition in enemy_drop_definitions:
        if enemy_drop_definition["File"] not in written_enemy_mdls_yaml_data:
            written_enemy_mdls_yaml_data.append(enemy_drop_definition["File"])
            mod_yml_str = mod_yml_str + """
- name: """ + enemy_drop_definition["File"] + """
  method: copy
  source:
  - name: """ + enemy_drop_definition["File"]
    return mod_yml_str

def write_mod_yml_file(mod_yml_st):
    with open("./Output/mod_enemies.yml", "w") as file:
        file.write(mod_yml_st)

def sort_enemy_drop_definitions(enemy_drop_definitions):
    sorted_enemy_drop_definitions = {}
    for enemy_drop_definition in enemy_drop_definitions:
        if enemy_drop_definition["File"] not in sorted_enemy_drop_definitions.keys():
            sorted_enemy_drop_definitions[enemy_drop_definition["File"]] = []
        sorted_enemy_drop_definitions[enemy_drop_definition["File"]].append(enemy_drop_definition)
    return sorted_enemy_drop_definitions

if __name__=="__main__":
    kh1_data_path = "C:/OpenKH/OpenKHEGS/data/kh1/"
    enemy_drop_definitions = get_enemy_drop_definitions()
    sorted_enemy_drop_definitions = sort_enemy_drop_definitions(enemy_drop_definitions)
    for file in sorted_enemy_drop_definitions.keys():
        enemy_bytes = get_enemy_data(kh1_data_path, file)
        enemy_bytes = remove_enemy_synth_drops(enemy_bytes, sorted_enemy_drop_definitions[file])
        write_enemy_mdls(enemy_bytes, file)
    mod_yml_string = get_mod_yml_string(enemy_drop_definitions)
    write_mod_yml_file(mod_yml_string)