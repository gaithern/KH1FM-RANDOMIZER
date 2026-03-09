from globals import read_json

from definitions import augment_strings
from write_item_descriptions import replace_specific_item_description

def update_accessory_descriptions(seed_json_data):
    accessory_location_map = {k: v for k, v in seed_json_data.items() if 2659100 <= int(k) <= 2659154}
    for accessory_location_id in accessory_location_map.keys():
        acc_val = int(accessory_location_id) - 2659100 + 17
        aug_val = accessory_location_map[accessory_location_id]
        aug_description = augment_strings[aug_val][1]
        replace_specific_item_description(acc_val, aug_description)

def write_augments(seed_json_file, settings_file):
    settings_data = read_json(settings_file)
    if settings_data.get("accessory_augments"):
        seed_json_data = read_json(seed_json_file)
        update_accessory_descriptions(seed_json_data)