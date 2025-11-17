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

def compile_heartless_dict(heartless_strings):
    heartless_dict = {}
    for heartless in heartless_strings:
        if heartless["Difficulty"]:
            difficulty = heartless["Difficulty"]
            if difficulty not in heartless_dict.keys():
                heartless_dict[difficulty] = []
            heartless_dict[difficulty].append(heartless)
    return heartless_dict

def choose_random_enemies(mdls_map, heartless_dict, seed):
    random.seed(seed)
    changes = {}
    for mdls in mdls_map:
        world          = mdls["World"]
        room           = mdls["Room"]
        ard            = mdls["File"]
        offset         = mdls["Offset"]
        value          = mdls["Value"]
        character      = mdls["Character"]
        easy           = mdls["Easy"] == "TRUE"
        medium         = mdls["Medium"] == "TRUE"
        hard           = mdls["Hard"] == "TRUE"
        easy_big       = mdls["Easy (Big)"] == "TRUE"
        hard_big       = mdls["Hard (Big)"] == "TRUE"
        easy_small     = mdls["Easy (Small)"] == "TRUE"
        hard_small     = mdls["Hard (Small)"] == "TRUE"
        if easy or medium or hard or easy_big or hard_big or easy_small or hard_small:
            key = ard  + " " + value + " " + character
            print(f"Key: {key}")
            if key not in changes.keys():
                possible_options = []
                difficulties = ["Easy", "Medium", "Hard", "Easy (Big)", "Hard (Big)", "Easy (Small)", "Hard (Small)"]
                for difficulty in difficulties:
                    if mdls[difficulty] == "TRUE":
                        if difficulty in heartless_dict.keys():
                            possible_options = possible_options + heartless_dict[difficulty]
                print(f"Possible options: {possible_options}")
                if len(possible_options) > 0:
                    randomized_enemy = random.choice(possible_options)
                    changes[key] = [{"randomized_enemy": randomized_enemy, "file": ard, "offset": hex(int(offset,16))}]
                    changes[key + " (2)"] = [{"randomized_enemy": randomized_enemy, "file": ard, "offset": hex(int(offset,16) + 0x20)}]
            else:
                changes[key].append({"randomized_enemy": changes[key][0]["randomized_enemy"], "file": changes[key][0]["file"], "offset": hex(int(offset,16))})
                changes[key + " (2)"].append({"randomized_enemy": changes[key][0]["randomized_enemy"], "file": changes[key][0]["file"], "offset": hex(int(offset,16) + 0x20)})
    return changes

def get_enemy_rando_log(changes):
    log = ""
    for key in changes.keys():
        for change in changes[key]:
            log = log + "Changed " + str(key) + " to " + change["randomized_enemy"]["Enemy"] + "\n"
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
            change_byte_array = bytearray(change["randomized_enemy"]["String"], "utf-8")
            
            print("Changed " + str(key) + " to " + change["randomized_enemy"]["Enemy"])
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
    if "randomize_enemies" in settings_data.keys():
        if settings_data["randomize_enemies"]:
            mdls_map = get_mdls_map()
            heartless_strings = get_heartless_strings()
            heartless_dict = compile_heartless_dict(heartless_strings)
            changes = choose_random_enemies(mdls_map, heartless_dict, settings_data["seed"])
            change_ard_bytes(kh1_data_path, changes)
            enemy_rando_log = get_enemy_rando_log(changes)
            write_enemy_rando_log(kh1_data_path, enemy_rando_log)

if __name__ == "__main__":
    write_enemies()