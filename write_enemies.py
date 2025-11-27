from tkinter import filedialog
import csv
import json
import os
import random

def get_mdls_map():
    with open('./Documentation/KH1FM Documentation - MDLS Map.csv', mode = 'r') as file:
        mdls_map = []
        mdls_map_data = csv.DictReader(file)
        for line in mdls_map_data:
            mdls_map.append(line)
    return mdls_map

def get_heartless_strings():
    with open('./Documentation/KH1FM Documentation - Heartless Strings.csv', mode = 'r') as file:
        heartless_strings = []
        heartless_strings_data = csv.DictReader(file)
        for line in heartless_strings_data:
            heartless_strings.append(line)
    return heartless_strings

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def get_bytes(file_path):
    with open(file_path, mode = 'rb') as file:
        return bytearray(file.read())

def write_bytes_to_file(file, bytes):
    with safe_open_wb('./Working/' + file) as open_file:
        open_file.write(bytes)

def compile_heartless_choices(heartless_strings):
    heartless_choices = {}
    
    heartless_string_lkp = {}
    for heartless in heartless_strings:
        heartless_string_lkp[heartless["Enemy"]] = heartless["String"]
    
    for heartless in heartless_strings:
        heartless_choices[heartless["String"]] = []
        for key in heartless.keys():
            if key not in ["Enemy", "String"]:
                if heartless[key] == "TRUE":
                    heartless_choices[heartless["String"]].append(heartless_string_lkp[key])
    return heartless_choices

def choose_random_enemies(mdls_map, heartless_choices, seed):
    random.seed(seed)
    changes = {}
    for mdls in mdls_map:
        world            = mdls["World"]
        room             = mdls["Room"]
        ard              = mdls["File"]
        offset           = mdls["Offset"]
        value            = mdls["Value"]
        character_string = mdls["Value"].replace(".mdls", "")
        character        = mdls["Character"]
        randomize        = mdls["Randomize"] == "TRUE"
        key              = ard  + " " + value + " " + character
        if randomize:
            possible_options = heartless_choices[character_string]
            if len(possible_options) > 0:
                randomized_enemy = random.choice(possible_options)
                changes[key] = [{"randomized_enemy": randomized_enemy, "file": ard, "offset": hex(int(offset,16))}]
                changes[key + " (2)"] = [{"randomized_enemy": randomized_enemy, "file": ard, "offset": hex(int(offset,16) + 0x20)}]
    return changes

def get_enemy_rando_log(changes):
    log = ""
    for key in changes.keys():
        for change in changes[key]:
            log = log + "Changed " + str(key) + " to " + change["randomized_enemy"] + "\n"
    return log

def write_enemy_rando_log(kh1_data_path, enemy_rando_log):
    with open(kh1_data_path + "enemy_rando_log.txt", "w") as text_file:
        text_file.write(enemy_rando_log)

def change_ard_bytes(kh1_data_path, changes):
    for key in changes.keys():
        print(f"Changes for {key}")
        for change in changes[key]:
            file = change["file"]
            offset = int(change["offset"], 16)
            change_byte_array = bytearray(change["randomized_enemy"], "utf-8")
            
            print("Changed " + str(key) + " to " + change["randomized_enemy"])
            print_str = ""
            for byte in change_byte_array:
                print_str = print_str + hex(byte) + " "
            print(print_str)
            
            bytes = get_bytes(kh1_data_path + file)
            i = 0
            for changed_byte in change_byte_array:
                bytes[offset + i] = change_byte_array[i]
                i = i + 1
            write_bytes_to_file(file, bytes)

def write_enemies(settings_file = None):
    kh1_data_path = "./Working/"
    settings_data = get_settings_data(settings_file)
    if "randomize_heartless" in settings_data.keys():
        if settings_data["randomize_heartless"]:
            mdls_map = get_mdls_map()
            heartless_strings = get_heartless_strings()
            heartless_choices = compile_heartless_choices(heartless_strings)
            changes = choose_random_enemies(mdls_map, heartless_choices, settings_data["seed"])
            change_ard_bytes(kh1_data_path, changes)
            enemy_rando_log = get_enemy_rando_log(changes)
            write_enemy_rando_log(kh1_data_path, enemy_rando_log)

if __name__ == "__main__":
    write_enemies()