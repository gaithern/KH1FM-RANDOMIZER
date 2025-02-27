from tkinter import filedialog
import csv
import json

from definitions import sora_ability_item_ids

def get_level_up_stats_definitions():
    with open('./Documentation/KH1FM Documentation - Battle Table Sora Level Up Stats.csv', mode = 'r') as file:
        level_up_stats_definitions = []
        level_up_stats_data = csv.DictReader(file)
        for line in level_up_stats_data:
            level_up_stats_definitions.append(line)
    return level_up_stats_definitions

def get_level_up_abilities_definitions():
    with open('./Documentation/KH1FM Documentation - Battle Table Sora Level Up Abilities.csv', mode = 'r') as file:
        level_up_abilities_definitions = []
        level_up_abilities_data = csv.DictReader(file)
        for line in level_up_abilities_data:
            level_up_abilities_definitions.append(line)
    return level_up_abilities_definitions

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def get_battle_table(kh1_data_path):
    with open(kh1_data_path + "/btltbl.bin", mode = 'rb') as file:
        return bytearray(file.read())

def update_battle_table(battle_table_bytes, replacements):
    for replacement_offset in replacements.keys():
        battle_table_bytes[replacement_offset] = replacements[replacement_offset]
    return battle_table_bytes

def get_battle_table_replacements(level_up_stats_definitions, level_up_abilities_definitions, seed_json_data):
    replacements = {}
    for level_up_stats_definition in level_up_stats_definitions:
        location_id = level_up_stats_definition["AP Location ID"]
        offset = int(level_up_stats_definition["Offset"],16)
        print("Getting replacement byte for level up location: " + level_up_stats_definition["AP Location Name"] + " with offset " + level_up_stats_definition["Offset"])
        replacements[offset] = 0
        if location_id in seed_json_data.keys():
            item_id = seed_json_data[location_id]
            if item_id >= 2641239 and item_id <= 2641245:
                replacements[offset] = (item_id % 2641239) + 1
        print("New value for level up location: " + level_up_stats_definition["AP Location Name"] + " with offset " + level_up_stats_definition["Offset"] + " is " + str(replacements[offset]))
    for level_up_abilities_definition in level_up_abilities_definitions:
        location_id = level_up_abilities_definition["AP Location ID"]
        offset = int(level_up_abilities_definition["Offset"],16)
        print("Getting replacement byte for level up location: " + level_up_abilities_definition["AP Location Name"] + " with offset " + level_up_abilities_definition["Offset"])
        replacements[offset] = 0
        if location_id in seed_json_data.keys():
            item_id = seed_json_data[location_id]
            if item_id >= 2641239 and item_id <= 2641245:
                replacements[offset] = (item_id % 2641239) + 1
            elif item_id in sora_ability_item_ids:
                replacements[offset] = item_id % 2643000 + 0x80
        print("New value for level up location: " + level_up_abilities_definition["AP Location Name"] + " with offset " + level_up_abilities_definition["Offset"] + " is " + str(replacements[offset]))
    return replacements

def output_battle_table(battle_table_bytes):
    with open('./Working/btltbl.bin', mode = 'wb') as file:
        file.write(battle_table_bytes)

def write_level_up_rewards(seed_json_file = None):
    kh1_data_path = "./Working/"
    level_up_abilities_definitions = get_level_up_abilities_definitions()
    level_up_stats_definitions = get_level_up_stats_definitions()
    seed_json_data = get_seed_json_data(seed_json_file)
    replacements = get_battle_table_replacements(level_up_stats_definitions, level_up_abilities_definitions, seed_json_data)
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_bytes = update_battle_table(battle_table_bytes, replacements)
    output_battle_table(battle_table_bytes)

if __name__ == "__main__":
    write_level_up_rewards()