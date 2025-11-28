import os
import json
import struct
from write_item_descriptions import build_item_description_string, build_item_description_string_array, concat_item_descriptions, build_item_description_bytes
from definitions import kh1_hex_to_char_map
from pprint import pprint

SETTINGS_EXCLUSIONS = ["starting_items", "synthesis_item_name_byte_arrays", "remote_location_ids", "slot_name"]
SENTINEL = b"\xCD" * 10
AP_ITEM_GUMMI_INDEXES = [0x77, 0x78, 0x79, 0x7A]
START_INVENTORY_WRITTEN_INDEX = 0x7B
GUMMI_ITEMS_WRITTEN_INDEX = 0x7C
TOO_LONG_DESCRIPTIONS = {
    "Bad Starting Weapons": "Bad Starting Wpns",
    "Consistent Finishers": "Consistent Fnshrs",
    "End Of The World Unlock": "EOTW Unlock",
    "Extra Shared Abilities": "Extra Shared Ablts",
    "Final Rest Door Key": "FR Door Key",
    "Force Stats On Levels": "Force Stats on LVs",
    "Halloween Town Key Item Bundle": "HT Key Item Bundle",
    "Homecoming Materials": "Homecomings Mats",
    "Individual Spell Level Costs": "Ind Spell LV Costs",
    "Keyblades Unlock Chests": "Keyblade Locking",
    "Randomize Ap Costs": "Random AP Costs",
    "Randomize Emblem Pieces": "Random E. Pieces",
    "Randomize Heartless": "Random Heartless",
    "Randomize Party Member Starting Accessories": "Random Start Accs",
    "Randomize Postcards": "Random Postcards",
    "Randomize Spell Mp Costs": "Random Spell MP",
    "Required Lucky Emblems Door": "Rqrd Embs Door",
    "Required Lucky Emblems Eotw": "Rqrd Embs EOTW",
    "Required Postcards": "Rqrd Postcards",
    "Scaling Spell Potency": "Scaling Spells",
    "Stacking World Items": "Stacking Worlds"}

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def replace_value_at_index(data: bytes, index: int, new_value: int) -> bytes:
    sentinel_index = data.index(SENTINEL)
    raw_values = data[:sentinel_index]
    tail = data[sentinel_index:]
    values = [v[0] for v in struct.iter_unpack("<H", raw_values)]
    if not (0 <= index < len(values)):
        raise IndexError(f"Index {index} out of range (0–{len(values)-1})")
    values[index] = new_value
    new_raw = b"".join(struct.pack("<H", v) for v in values)
    return new_raw + tail

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_gummi_item_description_bytes(kh1_data_path):
    with open(kh1_data_path + "/exchange/UK_gumi_mes_data.bin", mode = 'rb') as file:
        return bytearray(file.read())

def get_gummi_item_description_offset_bytes(kh1_data_path):
    with open(kh1_data_path + "/exchange/UK_gumi_mes_ofs.bin", mode = 'rb') as file:
        return bytearray(file.read())

def output_gummi_item_descriptions(new_gummi_item_description_bytes):
    with safe_open_wb('./Working/exchange/UK_gumi_mes_data.bin') as file:
        file.write(new_gummi_item_description_bytes)

def output_gummi_item_descriptions_offset_bytes(new_gummi_item_description_offset_bytes):
    with safe_open_wb('./Working/exchange/UK_gumi_mes_ofs.bin') as file:
        file.write(new_gummi_item_description_offset_bytes)

def replace_specific_gummi_item_string(index, description):
    kh1_data_path = "./Working/"
    if description in TOO_LONG_DESCRIPTIONS.keys():
        description = TOO_LONG_DESCRIPTIONS[description]
    gummi_item_description_bytes = get_gummi_item_description_bytes(kh1_data_path)
    gummi_item_description_string = build_item_description_string(gummi_item_description_bytes)
    gummi_item_descriptions = build_item_description_string_array(gummi_item_description_string)
    gummi_item_descriptions[index] = description
    new_gummi_item_description_string = concat_item_descriptions(gummi_item_descriptions)
    new_gummi_item_description_bytes = build_item_description_bytes(new_gummi_item_description_string)
    for byte in new_gummi_item_description_bytes:
        if byte is None:
            print("Something went wrong!!!")
    output_gummi_item_descriptions(bytes(new_gummi_item_description_bytes))

def get_gummi_items_lua():
    with open('./Template Luas/1fmRandoGummiItems.lua', mode = 'r') as file:
        gummi_items_lua_str = file.read()
    return gummi_items_lua_str

def output_gummi_items_lua_file(gummi_items_lua_str):
    with open('./Working/scripts/1fmRandoGummiItems.lua', mode = 'w') as file:
        file.write(gummi_items_lua_str)

def write_gummi_items(setings_file = None):
    kh1_data_path = "./Working/"
    settings_data = get_settings_data(setings_file)
    settings_num = 0
    
    # Handle Text
    for setting in settings_data.keys():
        print(f"Working on setting {setting}...")
        if setting not in SETTINGS_EXCLUSIONS:
            setting_name = setting.upper().replace("_", " ").title()
            setting_description = str(settings_data[setting]).replace("_", " ").title()
            print(f"Setting {setting} not in exclusions!  New name is {setting_name} and description is {setting_description}...")
            replace_specific_gummi_item_string(settings_num, setting_name)
            replace_specific_gummi_item_string(settings_num + 160, setting_description)
            settings_num = settings_num + 1
    for index in AP_ITEM_GUMMI_INDEXES:
        replace_specific_gummi_item_string(index,       "AP Items Received")
        replace_specific_gummi_item_string(index + 160, "")
    replace_specific_gummi_item_string(START_INVENTORY_WRITTEN_INDEX, "Start Written")
    replace_specific_gummi_item_string(START_INVENTORY_WRITTEN_INDEX + 160, "")
    replace_specific_gummi_item_string(GUMMI_ITEMS_WRITTEN_INDEX, "Gummi Written")
    replace_specific_gummi_item_string(GUMMI_ITEMS_WRITTEN_INDEX + 160, "")
    
    # Handle Offsets
    offsets = [0]
    gummi_item_description_bytes = get_gummi_item_description_bytes(kh1_data_path)
    for i in range(len(gummi_item_description_bytes)):
        if gummi_item_description_bytes[i] == 0x00:
            offsets.append(i + 1)
    offsets = offsets[:-2]
    gummi_item_description_offset_bytes = get_gummi_item_description_offset_bytes(kh1_data_path)
    for i in range(len(offsets)):
        gummi_item_description_offset_bytes = replace_value_at_index(gummi_item_description_offset_bytes, i, offsets[i])
    output_gummi_item_descriptions_offset_bytes(gummi_item_description_offset_bytes)
    
    
    gummi_items_lua_str = get_gummi_items_lua()
    gummi_items_lua_str = gummi_items_lua_str.replace("gummi_item_count = 0", f"gummi_item_count = {settings_num}")
    output_gummi_items_lua_file(gummi_items_lua_str)