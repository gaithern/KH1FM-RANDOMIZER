from tkinter import filedialog
import csv
import json
from pprint import pprint
import os

from definitions import augment_strings
from write_item_descriptions import replace_specific_item_description

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def update_accessory_descriptions(seed_json_data):
    accessory_location_map = {k: v for k, v in seed_json_data.items() if 2659100 <= int(k) <= 2659154}
    for accessory_location_id in accessory_location_map.keys():
        acc_val = int(accessory_location_id) - 2659100 + 17
        aug_val = accessory_location_map[accessory_location_id]
        aug_description = augment_strings[aug_val][1]
        replace_specific_item_description(acc_val, aug_description)

def write_augments(seed_json_file = None, settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data.get("accessory_augments"):
        seed_json_data = get_seed_json_data(seed_json_file)
        update_accessory_descriptions(seed_json_data)

if __name__=="__main__":
    write_augments()