from tkinter import filedialog
import csv
import json

from globals import BASE_DIR, read_csv, read_json, read_bytes, read_file, write_bytes, write_file

def get_rewards_definitions():
    reward_definitions = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Battle Table Reward Items.csv")
    for reward in reward_definitions:
        if reward["Chest Reference"] == "Link":
            reward["AP Location ID"] = None
        if reward["AP Location ID"] == "":
            reward["AP Location ID"] = None
    return reward_definitions

def get_replacement_short_item(item_index):
    short_value = item_index * 0x10
    return short_value

def get_replacement_short_reward(reward_index):
    short_value = (reward_index * 0x10) + 0xE
    return short_value

def get_chest_replacement(item_id, reward_definitions, location_id, location_name):
    item_id = item_id % 264000
    if item_id > 1000 and item_id < 2000: # Stock Item
        replacement_short = get_replacement_short_item(item_id % 1000)
    elif item_id > 2000 and item_id < 4000: # Ability
        reward_index = get_unused_reward_index(reward_definitions)
        reward_definitions[reward_index]["AP Location ID"] = location_id
        reward_definitions[reward_index]["AP Location Name"] = location_name
        replacement_short = get_replacement_short_reward(reward_index)
    else:
        print("Not normal item, replacing with generic AP Item")
        replacement_short = get_replacement_short_item(230)
    return replacement_short, reward_definitions

def get_reward_replacement(item_id):
    item_id = item_id % 264000
    if item_id > 1000 and item_id < 2000: # Regular Item
        return [0xF0, item_id % 1000]
    elif item_id > 2000 and item_id < 3000: # Shared Ability
        return [0xB1, item_id % 2000]
    elif item_id > 3000 and item_id < 4000: # Sora Ability
        return [0x01, item_id % 3000]
    else:
        print("Not normal item, replacing with generic AP Item")
        return [0xF0, 230]

def get_unused_reward_index(reward_definitions):
    i = 0
    while i < len(reward_definitions):
        if reward_definitions[i]["AP Location ID"] is None:
            return i
        i = i + 1

def get_all_chest_replacements(chest_definitions, reward_definitions, seed_json_data):
    replacements = {}
    for chest_definition in chest_definitions:
        print("Getting replacement byte for chest location: " + chest_definition["AP Location Name"] + " with offset " + chest_definition["Offset"])
        if chest_definition["AP Location ID"] in seed_json_data.keys():
            replacement_short, reward_definitions = get_chest_replacement(seed_json_data[chest_definition["AP Location ID"]], reward_definitions, chest_definition["AP Location ID"], chest_definition["AP Location Name"])
        else:
            print("Location ID not found in seed JSON data, replacing with Potion")
            replacement_short, reward_definitions = get_chest_replacement(2641001, reward_definitions, None, None)
        print("Replacement short: " + str(replacement_short))
        replacements[int(chest_definition["Offset"], 16)] = replacement_short
    return replacements, reward_definitions

def get_all_reward_replacements(reward_definitions, seed_json_data):
    replacements = {}
    for reward in reward_definitions:
        if reward["AP Location ID"] is not None:
            print("Getting replacement byte for reward location: " + reward["AP Location Name"] + " with offset " + reward["Offset"])
            if reward["AP Location ID"] in seed_json_data.keys():
                replacement_bytes = get_reward_replacement(seed_json_data[reward["AP Location ID"]])
            else:
                print("Location ID not found in seed JSON data, replacing with Potion")
                replacement_bytes = [0xF0, 1]
            replacements[int(reward["Offset"], 16)] = replacement_bytes
            print("Replacement bytes: " + str(replacement_bytes))
    return replacements

def update_globals_lua(globals_lua_str, replacements):
    return globals_lua_str.replace("chests = {}", "chests = " + json.dumps(replacements).replace("{\"", "{[").replace("\":", "] =").replace(", \"", ", ["))

def update_battle_table(battle_table_bytes, replacements):
    for replacement_offset in replacements.keys():
        battle_table_bytes[replacement_offset - 1] = replacements[replacement_offset][0]
        battle_table_bytes[replacement_offset] = replacements[replacement_offset][1]
    return battle_table_bytes

def write_chests_and_rewards(seed_json_file):
    kh1_data_path = BASE_DIR / "Working/"
    chest_definitions = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Chest Items.csv")
    reward_definitions = get_rewards_definitions()
    seed_json_data = read_json(seed_json_file)
    chest_replacements, reward_definitions = get_all_chest_replacements(chest_definitions, reward_definitions, seed_json_data)
    reward_replacements = get_all_reward_replacements(reward_definitions, seed_json_data)
    globals_lua_str = read_file(kh1_data_path / "scripts/io_packages/globals.lua")
    globals_lua_str = update_globals_lua(globals_lua_str, chest_replacements)
    write_file(kh1_data_path / "scripts/io_packages/globals.lua", globals_lua_str)
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    updated_battle_table = update_battle_table(battle_table_bytes, reward_replacements)
    write_bytes(kh1_data_path / "btltbl.bin", updated_battle_table)