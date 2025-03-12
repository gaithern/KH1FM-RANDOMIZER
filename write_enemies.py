from tkinter import filedialog
import csv
import json
import os
import random

def get_map_enemies():
    with open('./Documentation/KH1FM Documentation - Map Enemies.csv', mode = 'r') as file:
        map_enemies = []
        map_enemies_data = csv.DictReader(file)
        for line in map_enemies_data:
            map_enemies.append(line)
    return map_enemies

def get_enemy_categories():
    with open('./Documentation/KH1FM Documentation - Enemy Categories.csv', mode = 'r') as file:
        enemy_categories = []
        enemy_categories_data = csv.DictReader(file)
        for line in enemy_categories_data:
            enemy_categories.append(line)
    return enemy_categories

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

def choose_random_enemies(map_enemies, enemy_categories, seed):
    random.seed(seed)
    categories = ["Easy", "Medium", "Hard"]
    changes = {}
    for enemy in map_enemies:
        world          = enemy["World"]
        room           = enemy["Room"]
        original_enemy = enemy["Enemy"]
        file           = enemy["File"]
        offset         = enemy["Offset"]
        key = world + " " + room  + " " + original_enemy
        if key not in changes.keys():
            possible_options = []
            for category in categories:
                if enemy[category] == "TRUE":
                    possible_options = possible_options + enemy_categories[category]
            randomized_enemy = random.choice(possible_options)
            changes[key] = [{"randomized_enemy": randomized_enemy, "file": file, "offset": offset}]
        else:
            changes[key].append({"randomized_enemy": changes[key][0]["randomized_enemy"], "file": changes[key][0]["file"], "offset": offset})
    return changes

def compile_enemy_categories(enemy_categories):
    compiled_enemy_categories = {}
    for enemy in enemy_categories:
        if enemy["Category"] not in compiled_enemy_categories.keys():
            compiled_enemy_categories[enemy["Category"]] = []
        compiled_enemy_categories[enemy["Category"]].append({"enemy": enemy["Enemy"], "value": enemy["String"]})
    return compiled_enemy_categories

def get_enemy_rando_log(changes):
    log = ""
    for key in changes.keys():
        for change in changes[key]:
            log = log + "Changed " + str(key) + " to " + change["randomized_enemy"]["enemy"] + "\n"
    return log

def write_enemy_rando_log(kh1_data_path, enemy_rando_log):
    with open(kh1_data_path + "enemy_rando_log.txt", "w") as text_file:
        text_file.write(enemy_rando_log)

def change_ard_bytes(kh1_data_path, changes):
    for key in changes.keys():
        for change in changes[key]:
            file = change["file"]
            offset = int(change["offset"], 16)
            change_byte_array = bytearray(change["randomized_enemy"]["value"], "utf-8")
            
            print("Changed " + str(key) + " to " + change["randomized_enemy"]["enemy"])
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
        if settings_data["randomize_enemies"] != "off":
            map_enemies = get_map_enemies()
            enemy_categories = get_enemy_categories()
            enemy_categories = compile_enemy_categories(enemy_categories)
            changes = choose_random_enemies(map_enemies, enemy_categories, settings_data["seed"])
            change_ard_bytes(kh1_data_path, changes)
            enemy_rando_log = get_enemy_rando_log(changes)
            write_enemy_rando_log(kh1_data_path, enemy_rando_log)

if __name__ == "__main__":
    write_enemies()